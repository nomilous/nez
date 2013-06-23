Notice    = require 'notice'
async     = require('also').inject.async
tools     = require '../tools'
Realizers = require '../realizers'
eo        = require 'eo'

module.exports = (title, opts, objectiveFn) ->

    context    = eo.validate.apply this, arguments
    objective  = async

        #
        # asynchronous config assembly for args injection into eo
        # 

        beforeAll: (done, inject) -> 

            context.tools = tools

            #
            # create local messenger for interactions with 
            # console and users personal notice middleware
            # 
            #  see: https://github.com/nomilous/notice/tree/develop
            #

            notice = Notice.create 'objective', context.messenger || eo.messenger
            

            Realizers context, notice, (error, realizers) -> 

                return done error if error?

                #
                # realizer collection class is online and 
                # listening for realizers
                #

                context.realizers = realizers


                #
                # injects into eo module runner
                # 
                # arg1 - objective context 
                # arg2 - local notifier
                # argN - remaining args as called externally
                #

                inject.first[0]   = context
                inject.first[1]   = notice


                #
                # proceed to injection
                #

                done()


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


