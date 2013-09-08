#
# Realizers Collection (singleton)
# ================================
# 
# 
#

{defer} = require 'when'
spawner = require './spawner'

module.exports = new ( class Realizers

    autospawn: false

    get: -> 

        getting = defer()
        process.nextTick => 

            console.log AUTOSPAWN: @autospawn
            getting.resolve 'REALIZER'

        getting.promise

    update: -> 

        updating = defer()
        process.nextTick => 

            updating.resolve 'REALIZER'

        updating.promise


)
