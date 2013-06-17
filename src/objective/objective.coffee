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

    options      = title: title
    options[key] = opts[key] for key of opts
    objective    = inject.sync

        #
        # beforeAll injects context (opts hash) and
        # the notifier as the first 2 args
        #

        beforeAll: (context) -> 

            context.first.push options
            context.first.push notice.create 'objective', opts.messenger || eo.messenger
        

        (context, notifier, fn) -> eo options, notifier, fn

    objective objectiveFn
