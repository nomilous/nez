#
# attached realizers collection
#

collection = {}
allowSpawn = false

factory = (context, notice) -> 

    realizers = 

        get: (opts, callback) -> 

            opts ||= {}

            unless opts.id? 

                throw new Error 'realizers.get(opts, callback) opts.id as the realizer id'


            unless collection[opts.id]?

                unless allowSpawn

                    return callback new Error 'missing realizer'


                realizers.spawn opts


    Object.defineProperty realizers, 'allowSpawn', 
        
        set: (value) -> allowSpawn = value if typeof value == 'boolean'


    return realizers


module.exports = factory
