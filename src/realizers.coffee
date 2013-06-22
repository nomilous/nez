#
# attached realizers collection
#

collection = {}

module.exports = 

    get: (opts, callback) -> 

        opts ||= {}

        unless opts.id? 

            throw new Error 'realizers.get(opts, callback) opts.id as the realizer id'


        unless collection[opts.id]?

            return callback new Error 'missing realizer'

