async = require 'async'
passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
Settings = require 'settings'

config = new Settings(require '../../config/config')

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  UserResource.Fetch id, done

passport.use new LocalStrategy {
  usernameField: 'login'
  passwordField: 'pass'
},(username, password, done) ->
    UserResource.FetchByLogin username, (err, user) ->
      return done err if err? and err.status isnt 'not_found'
      return done null, false, {message: 'Incorrect Username/password'} if err? or !(user?) or !user.ValidatePassword password
      return done null, user

exports.mount = (app) ->

  app.get '/login', (req, res) ->
    res.render 'signin'

  app.post '/login', passport.authenticate('local'), (req, res) ->
    res.redirect '/'

  app.post '/logout', (req, res) ->
    req.logout()
    res.redirect '/'

  app.post '/signup', (req, res) ->

    async.auto
      existingUser: (done) ->
        UserResource.FetchByLogin req.body.user.login, (err, user) ->
          return done() if err?

          done {status: 500, message: 'Existing User'}

      user: ['existingUser', (done, results) ->
        UserResource.Deserialize req.body.user, done]

      saveUser: ['user', (done, results) ->
        results.user.Save done]

    , (err, results) ->
      return res.locals.sendError err if err?

      res.send 200

