Notice = require 'notice'
async  = require('also').inject.async
tools  = require '../tools'
ipso   = require 'ipso'

module.exports = (title, optionalOpts, realizerFn) -> 

    {context, realizerFn} = ipso.validate.apply this, arguments
    context.tools = tools

    #
    # asynchronous config assembly of args for injection:
    # 
    #        ipso( context, notice, realizerFn )
    #

    realizer = async

        beforeAll: (done, inject) -> 

            Notice.connect 'realizer', context, (error, notice) -> 

                inject.first[0] = context
                inject.first[1] = notice
                done()

        ipso


    realizer realizerFn
