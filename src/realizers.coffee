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

        realizers = 

            #
            # realizers.task( title, ref )
            # 
            # emits a task to the specified realizer
            # 
            # title  - title of the task to run
            # ref.id - id of the realizer to run the task 
            # 

            #
            # TODO: task returns a promise
            # 
            #       pending: 
            # 
            #       - Notice.task() for the task
            #       - Notice persistor plugin for tasks to span restarts / scale 
            #

            task: (title, ref) -> 

                realizers.get ref, (err, realizer) -> 

                    realizer.task title






            #
            # realizers.get( ref, callback ) 
            # 
            # calls back with a reference to the
            # realizer specified in ref.id
            # 

            get: (ref, callback) -> 

                unless ref? and ref.id? 

                    throw new Error 'realizers.get(ref, callback) requires ref.id as the realizer id'


                unless collection[ref.id]?

                    unless ref.script?

                        return callback new Error 'missing realizer'

                    unless ref.script.match( /\.(lit)*coffee$/ )?

                        return callback new Error 'nez supports only coffee-script realizers' # for now


                    context.tools.spawn ref, callback


        return callback null, realizers


module.exports = factory