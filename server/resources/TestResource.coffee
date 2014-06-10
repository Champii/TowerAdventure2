Resource = require '../helpers/Resource'
Resource.db = require '../storage/TestDb'



class TestResource extends Resource

  constructor: (blob) ->
    super blob

Resource.type = TestResource
module.exports = TestResource
