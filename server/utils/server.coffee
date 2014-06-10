express = require 'express'
path = require 'path'
Settings = require 'settings'
exec = require('child_process').exec
http = require 'http'
coffeeMiddleware = require 'coffee-middleware'
passport = require 'passport'

config = new Settings(require '../../config/config')
routes = require '../routes'
assets = require '../../config/assets.json'
sockets = require '../socket/socket'
processors = require '../processors'
bus = require '../bus'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
expressSession = require 'express-session'

TestResource = require '../resources/TestResource'

app = null

tdRoot = path.resolve __dirname, '../..'

exports.makeServer = () ->

  app = express()

  app.use coffeeMiddleware
      src: path.resolve tdRoot, 'public'
      # compress: true
      prefix: 'js'
      bare: true
      force: true


  app.use require('connect-cachify').setup assets,
    root: path.join tdRoot, 'public'
    production: config.minify

  app.use cookieParser()
  app.use bodyParser()
  app.use expressSession secret: 'td2 secret'

  app.use express.static path.resolve tdRoot, 'public'

  app.use passport.initialize()
  app.use passport.session()

  app.set 'views', path.resolve tdRoot, 'public/views'
  app.engine '.jade', require('jade').__express
  app.set 'view engine', 'jade'

  # app.use express.compress()

  routes.mount app

  processors.init()

  server = http.createServer app

  server.listen config.host.port

  sockets.init server

  TestResource.List (err, tests) ->

    console.log tests
    tests[0].test1 = 2
    tests[0].Save (err) ->
      TestResource.Fetch 1, (err, test1) ->
        console.log err, test1

