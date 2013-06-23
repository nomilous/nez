Notice = require 'notice'
async  = require('also').inject.async
tools  = require '../tools'
ipso   = require 'ipso'

module.exports = (title, optionalOpts, realizerFn) -> 

    {context, realizerFn} = ipso.validate.apply this, arguments

    console.log 'START REALIZER', 
        context:  context
        realizer: realizerFn.toString()

    # console.log JSON.stringify

    #     realize:

    #         #
    #         # got all the bits?
    #         # 

    #         transport: process.env['OBJECTIVE_transport']
    #         address: process.env['OBJECTIVE_address']
    #         port: process.env['OBJECTIVE_port']
    #         title: title

    #     null
    #     2


