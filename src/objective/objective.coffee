notice         = require 'notice'
eo             = require 'eo'
inject         = require('also').inject

module.exports = (title, opts, objectiveFn) ->

    unless typeof title == 'string'
        throw new Error 'objective(title, opts, fn) requires title as string'

    if typeof opts == 'function'
        objectiveFn = opts
        opts        = {}

    unless typeof objectiveFn == 'function'
        throw new Error 'objective(title, opts, fn) requires function as last argument'


    #
    # configure the objective
    #

    options        = title: title
    options.tools  = require '../tools'
    options[key]   = opts[key] for key of opts
    objective      = inject.async

        #
        # beforeAll injects context (opts hash) and
        # the notifier as the first 2 args
        #

        beforeAll: (done, inject) -> 

            inject.first[0] = notice.listen 'realizers', options, (error) -> done error 
            inject.first[1] = notice.create 'objective', opts.messenger || eo.messenger

        #
        # assign a default error handler if none was configured
        #

        error: options.error || (

            console.log 'WARNING', 'objective without error handler'
            (error) -> console.log 'ERROR', error

        )
        
        #
        # inject into eo
        #

        eo


    #
    # start the objective
    #

    objective objectiveFn


