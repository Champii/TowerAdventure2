sql = require './connectors/sql'
tests = sql.table 'tests'

class TestDb

  constructor: ->

  @Fetch: (id, done) ->
    tests.Find id, done

  @List: (done) ->
    tests.Select 'id', {}, {}, done

  @Save: (blob, done) ->
    tests.Save blob, done

module.exports = TestDb
