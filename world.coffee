### World - Runs the game world like a pro! ###

EventEmitter = (require 'events').EventEmitter
# TODO - rename 'map' to 'Map' etc.
map = (require './controllers/maps').Map  # Map functions like render, etc.
mob = (require './controllers/mobs').Mob  # Mob functions like move, etc.
tower = (require './controllers/towers').Tower  # Tower functions like attack, etc.

# Initialize a new game
# Called when the player first starts or elects to restart

exports.World = class World extends EventEmitter

  constructor: ->
    ### Initial config ###
    @gameTime = 3000  # every 3000ms, the game progresses

    ### Start the game!! ###
    @game = setInterval ->
      world.gameLoop()
    , @gameTime
    
    # For some reason we have to wait to load everything or else 'world' doesn't get defined as a global var
    self = @
    @load = setTimeout ->
      self.loadEntities( { map: 'hiddenvalley' } )
    , 1000
    
      
  loadEntities: (json, callback) ->
    
    ### Load the map ###
    # First level: Hidden Valley
    @maps = []
    @maps.push new map json.map
    @emit 'load', 'map', _map for _map in @maps

    ### Load and spawn the towers ###
    # First map has one tower: Cannon
    @towers = []
    @towers.push new tower 'cannon'

        
    ### Load the mobs ###
    # Each map can have many mobs
    @mobs = []
    for _map in @maps
      for mobId in _map.mobs
        _mob = new mob mobId
        @emit 'load', 'mob', _mob
        @mobs.push _mob

    # Mobs don't know about the 'load' event because they aren't instantiated in time
    @emit 'load', 'tower', _tower for _tower in @towers

    # They exist in memory but need to be spawned
    @mobs[0].spawn [0, 0]
    @mobs[1].spawn [1, 0]
    @towers[0].spawn [4, 4]

         
  gameLoop: ->
    # One iteration of a game loop
    # Runs every '@gameTime' seconds
    @emit 'gameLoop'  # A bunch of stuff listens to this to know when a 'turn' has finished    

    @toString (json) ->
      console.log json  # Have to log via console because of this lame array.
    
  destroy: ->
    logger.info 'DESTROYING the game ;('
    clearInterval @game # stop game clock
    maps = []
    mobs = []
    towers = []
  
  
  # Output current game status
  toString: (callback) ->
    callback @maps[0].grid
    