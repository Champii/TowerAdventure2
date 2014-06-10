moduleKeywords = ['inc', 'extended', 'constructor']

class Module

  currentConstruct: null

  constructor: (args...) ->
    argsArr = []
    for arg in args
      argsArr.push arg

    if @currentConstruct == null
      @currentConstruct = @inc

    i = 0
    if @currentConstruct?
      for obj in @currentConstruct
        @currentConstruct = obj.prototype.inc
        if argsArr[i]?
          obj.apply this, argsArr[i++]
        else
          obj.apply this
        @currentConstruct = obj.prototype.inc

  @include: (obj) ->
    throw('include(obj) requires obj') unless obj
    for key, value of obj.prototype when key not in moduleKeywords
      @::[key] = value
    if !(@::['inc']?)
      @::['inc'] = []
    @::['inc'].push obj
    @

  _super: (args...) ->
    @__super args, @inc, @GetCaller(), arguments.callee.caller

  __super: (args, incRec, caller, func) ->
    for obj in incRec
      for key, value of obj.prototype
        if key == caller && value != func
          return value.apply this, args
      if obj.prototype.inc?
        return @__super args, obj.prototype.inc, caller, func


  GetCaller: ->
    orig = Error.prepareStackTrace
    Error.prepareStackTrace = (_, stack) ->
      return stack
    err = new Error
    Error.captureStackTrace(err, arguments.callee)
    name = err.stack[1].getFunctionName()?.split('.')
    Error.prepareStackTrace = orig
    name[name.length - 1]

module.exports = Module
