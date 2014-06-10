_ = require 'underscore'

routes = [
  'api'
  'auth'
  'api_404'
  'html']

exports.mount = (app) ->
  _(routes).each (route) ->
    require('./' + route + '_routes.coffee').mount(app);
