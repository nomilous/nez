module.exports = (title, fn) -> 

    console.log 'START REALIZER'

    console.log JSON.stringify

        realize:

            transport: process.env['OBJECTIVE_transport']
            address: process.env['OBJECTIVE_address']
            port: process.env['OBJECTIVE_port']
            title: title

        null
        2
