notice = require 'notice'
async  = require('also').inject.async
tools  = require '../tools'
eo     = require 'eo'

module.exports = (title, opts, objectiveFn) ->

    context    = eo.validate.apply this, arguments
    objective  = async

        #
        # asynchronous config assembly for args injection into eo
        # 

        beforeAll: (done, inject) -> 

            context.tools   = tools
            inject.first[0] = notice.listen 'realizers', context, (error) -> done error 
            inject.first[1] = notice.create 'objective', context.messenger || eo.messenger

        #
        # assign a default error handler if none was configured
        #

        error: context.error || (

            console.log 'WARNING', 'objective without error handler'
            (error) -> console.log 'ERROR', error

        )
        
        #
        # inject into eo(context, notifier, objectiveFn)
        #

        eo


    #
    # start the objective
    #

    objective objectiveFn


