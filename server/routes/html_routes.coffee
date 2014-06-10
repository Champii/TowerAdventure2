exports.mount = (app) ->

  # app.get '/(js|css|img|fonts)/*', (req, res) ->
  #   res.send 404

  app.get '/game', (req, res) ->

    user = {}
    if req.user?
      user = req.user

    res.render 'game',
    user: user

  app.get '*', (req, res) ->

    user = {}
    if req.user?
      user = req.user

    res.render 'index',
      user: user
