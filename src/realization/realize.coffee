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

                if error? 

                    #
                    # some libs generate errors that are not
                    # instances of Error ....
                    #

                    
                    return done new Error error unless error instanceof Error # .... spank them!
                    return done error


                inject.first[0] = context
                inject.first[1] = notice
                done()

        error: (error) -> console.log 'Realizer error!', error

        ipso


    realizer realizerFn
