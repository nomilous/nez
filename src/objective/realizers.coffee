#
# Realizers Collection (singleton)
# ================================
# 
# 
#

{defer} = require 'when'
spawner = require './spawner'

module.exports = new ( class Realizers

    get: -> 

        getting = defer()
        process.nextTick -> getting.resolve 'REALIZER'
        getting.promise

)
