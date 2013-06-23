ipso = require 'ipso'

module.exports = (title, fn) -> 

    console.log 'START REALIZER'

    console.log JSON.stringify

        realize:

            #
            # got all the bits?
            # 

            transport: process.env['OBJECTIVE_transport']
            address: process.env['OBJECTIVE_address']
            port: process.env['OBJECTIVE_port']
            title: title

        null
        2


