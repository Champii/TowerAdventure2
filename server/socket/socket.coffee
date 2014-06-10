socket = require 'socket.io'

bus = require '../bus'

exports.init = (server) ->
  io = socket.listen server, log: false

  io.sockets.on 'connection', (socket)->
    hs = socket.handshake
    userId = hs.user_id

    socket.once 'disconnect', () ->

