### Mob client-side code ###

# Model mimics server-side model. May do some backbone-ish later.
# See /models/mob-model for defintion

$ ->
  class window.Mob
    constructor: (data) ->
      @moveConst = 0.825
      { @uid, @x, @y, @dx, @dy, @speed, @maxHP, @curHP, @symbol } = data
  
    move: (mobdata) ->
      { @x, @y, @dx, @dy, @speed } = mobdata

    # Update mob info (movement, etc) each frame
    update: ->
      # Calculate new trajectory
      console.log "DX: #{@dx} DY: #{@dy}"
      @x = @x + (@dx*@speed*@moveConst/FPS)
      @y = @y + (@dy*@speed*@moveConst/FPS)
      console.log "X: #{@x} Y: #{@y}"

      
    # Draw a mob on the map
    draw: (context) ->
      context.fillStyle='#000'
      x = @getLoc @x
      y = @getLoc @y
      context.font = '40pt Pictos'
      context.fillText @symbol, x+2, y-10

    pause: ->
      @dx = 0
      @dy = 0
      
    getLoc: (loc) ->
       if typeof loc is 'number'
         return (loc*squarewidth)+0.5