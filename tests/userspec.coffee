cfg = require '../config/config.js'  # contains API keys, etc'
Users = (require '../controllers/user.js').Users

# Unit Tests
describe 'List all users: /users', -> 
  it 'Returns at least one valid user', ->
    user = new Users
    user.get null, (json) ->
      expect(json).toBeDefined()
      expect(json[0].name).toBeDefined()
      expect(json[0].id).toBeDefined()
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()

describe 'List a single user: /users/:id', ->
  it 'Returns only one valid user', ->
    user = new Users
    user.get '0', (json) ->
      expect(json).toBeDefined()
      expect(json[0].name).toBeDefined()
      expect(json[0].id).toBeDefined()
      expect(json[1]).toBeUndefined()
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()