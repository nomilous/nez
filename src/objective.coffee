eo             = require 'eo'
module.exports = (title, opts, fn) ->

    unless typeof title == 'string'
        throw new Error 'objective(title, opts, fn) requires title as string'

    if typeof opts == 'function'
        fn   = opts
        opts = {}

    unless typeof fn == 'function'
        throw new Error 'objective(title, opts, fn) requires function as last argument'


    #
    # start objective
    #

    options = title: title
    options[key] = opts[key] for key of opts
    eo options, fn

    