### Mob Tests ###
basedir = '../../'
App = require basedir + 'app.js'
World = (require basedir + 'world.js').World

Obj = (require basedir + 'controllers/utils/object.js').Obj



# Unit Tests
describe 'World world.js', ->
  beforeEach ->
    global.world = new Obj # Required because maps relies on 'world' for some events
    
    # Stub data

    @world = new World

  it 'Loads some stuff', ->
    expect(@world).toBeDefined()