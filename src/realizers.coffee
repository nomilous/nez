#
# attached realizers collection
#

Notice     = require 'notice'
collection = {}

factory    = (context, notice, callback) -> 

    Notice.listen 'realizers', context, (error) -> 

        #
        # async factory class, it callsback with the
        # realizers collection object once the Notice 
        # hub is up and listening for realizers
        # 

        return callback error if error?

        return callback null, 

            #
            # realizers.get( opts, callback ) 
            # 
            # calls back with a reference to the
            # realizer specified in opts.id
            # 


            get: (opts, callback) -> 

                opts ||= {}

                unless opts.id? 

                    throw new Error 'realizers.get(opts, callback) requires opts.id as the realizer id'


                unless collection[opts.id]?

                    unless opts.script?

                        return callback new Error 'missing realizer'

                    unless opts.script.match( /\.(lit)*coffee$/ )?

                        return callback new Error 'nez supports only coffee-script realizers' # for now


                    context.tools.spawn opts, callback


module.exports = factory
