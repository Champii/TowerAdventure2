Settings = require 'settings'

superagent = require 'superagent'
agent = superagent.agent()

config = new Settings(require('../../../config/config'))

class Client

  constructor: (@app) ->
    @identity =
      login: ''
      pass: ''
    @request = require('supertest')(@app)

  Login: (done) ->
    @request
      .post('/login')
      .send(@identity)
      .expect(302)
      .end (err, res) ->
        return done err if err?

        agent.saveCookies res
        done()

  Get: (url, done) ->
    req = @request.get url

    @AttachCookie req
    req.expect 200, done

  Post: (url, data, done) ->
    req = @request.post url

    @AttachCookie req
    req
      .send(data)
      .expect(200)
      .end done

  Put: (url, data, done) ->
    req = @request.put url

    @AttachCookie req
    req
      .send(data)
      .expect(200)
      .end done

  AttachCookie: (req) ->
    agent.attachCookies req

  SetIdentity: (login, pass) ->
    @identity.login = login
    @identity.pass = pass

module.exports = Client
