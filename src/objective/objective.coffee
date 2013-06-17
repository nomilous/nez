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
        # assign user defined beforeEach or default 
        #

        beforeEach: opts.beforeEach || (context) ->

        #
        # beforeAll injects context (opts hash) and
        # the notifier as the first 2 args
        #

        beforeAll: (context) -> 

            context.first.push options
            context.first.push notice.create 'objective', opts.messenger || eo.messenger

            #
            # run userdefined beforeAll() if present
            #

            if typeof opts.beforeAll == 'function'

                opts.beforeAll.apply null, arguments
        

        (context, notifier, fn) -> eo options, notifier, fn


    objective objectiveFn
    
