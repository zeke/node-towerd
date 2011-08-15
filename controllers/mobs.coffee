cfg = require '../config/config.js'    # contains API keys, etc.
redis = require 'redis'
EventEmitter = (require 'events').EventEmitter

# Models
mobModel = require '../models/mob-model.js'

exports.Mob = class Mob extends EventEmitter
  constructor: (name) ->
    @type = 'mob' # So other objects know I'm a mob
    name = name.toLowerCase()   # In case someone throws in some weird name
    logger.info 'Loading mob: ' + name
    toLoad = (require '../data/mobs/' + name + '.js').mob
    
    @uid = Math.floor Math.random()*10000000  # Generate a unique ID for each instance of this mob    
    @loc = [null, null]  # Hasn't been spawned yet, so position is null
    { @dx, @dy } = 0 # Mob will be stationary when spawned
    { id: @id, name: @name, class: @class, active: @active, speed: @speed, maxHP: @maxHP, curHP: @curHP, symbol: @symbol } = toLoad
    @emit 'load'
    
    ### Event Emitters ###
    world.on 'gameLoop', =>
      @move @dx, @dy, @speed, (json) ->
      
    world.on 'fire', (obj, target) =>
      if obj.type == 'tower'
        if @uid == target.uid.valueOf()
          # Holy shit, the shot was fired at me!
          @hit(obj.damage)
          
  spawn: (loc, dx, dy, callback) ->
    @curHP = @maxHP # Always spawn with full life (for now!)
    { @loc, @dx, @dy } = { loc, dx, dy }
    
    @emit 'spawn'
    logger.info 'Spawning mob [' + @id + '] at (' + @loc + ') with UID: ' + @uid
    @save ->
   
  hit: (damage) ->
    @curHP = @curHP - damage
    if @curHP > 0
      logger.info "MOB #{@uid} [#{@curHP}/#{@maxHP}] was hit for #{damage}"
      @emit 'hit'
    else
      # mob is dead!
      logger.info "MOB [#{ @uid }] is dead!"
      @emit 'die'
  
  move: (dx, dy, speed, callback) ->
    oldloc = @loc
    
    @loc = [(@loc[0] + dx) * speed, (@loc[1] + dy) * speed]
    newloc = @loc
    
    if oldloc != newloc # Don't do anything if we haven't actually moved
      mobModel.find { uid: @uid }, (err, mob) =>

        if(err)
          logger.error 'Error finding mob: {@uid} ' + err
        else
          mob[0].loc = newloc
          mob[0].save (err) =>
            if (err)
              logger.warn 'Error saving mob: {@uid} ' + err
            else

              @emit 'move', oldloc
              logger.info 'MOB ' + @uid + ' [' + @id + '] moved to (' + @loc[0] + ',' + @loc[1] + ')'

  save: (callback) ->
    # Save to DB
    newmob = new mobModel ( { uid: @uid, id: @id, name: @name, class: @class, speed: @speed, maxHP: @maxHP, curHP: @curHP, loc: @loc } )
    newmob.save (err, saved) ->
      if err
        logger.error 'Error saving: ' + err
    
  showString: (callback) ->
    output = 'MOB ' + @uid + ' [' + @id + ']  loc: (' + @loc[0] + ', ' + @loc[1] + ')  HP: ' + @curHP + '/' + @maxHP
    callback output