#
# attached realizers collection
#

collection = {}

factory = (context, notice) -> 

    spawn = (opts, callback) -> callback()


    get: (opts, callback) -> 

        opts ||= {}

        unless opts.id? 

            throw new Error 'realizers.get(opts, callback) requires opts.id as the realizer id'


        unless collection[opts.id]?

            unless opts.script?

                return callback new Error 'missing realizer'


            spawn opts, callback


module.exports = factory
