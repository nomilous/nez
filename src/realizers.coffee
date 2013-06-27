#
# attached realizers collection
#

Notice     = require 'notice'
wait       = require('also').schedule.wait


factory    = (context, notice, callback) -> 

    collection = {}

    Notice.listen 'realizers', context, (error, Realizers) ->
                                                    #
                                                    # middleware pipeline carrying
                                                    # messages from remote realizers
                                                    # 

        Realizers.use (msg, next) -> 

            switch msg.context.title

                when 'realizer::start'

                    # 
                    # remote realizer has established connection
                    # 
                    # * store reference to the message pipeline in the collection
                    # * key on script name (good enough for now, but may soon collide)
                    # 

                    script = msg.payload.properties.script
                    reply  = msg.reply
                    collection[script] = reply
                    

            next()


        #
        # async factory class, it callsback with the
        # realizers collection object once the Notice 
        # hub is up and listening for realizers
        # 

        return callback error if error?

        integrations = 

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

                integrations.get ref, (err, realizer) -> 

                    console.log '\n\n\nGOT REALIZER!', realizer

                    #
                    # realizer.task title
                    # 




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


                    #
                    # spawning local realizer requires connection address
                    #

                    process.env['UPLINK_transport'] = context.listening.transport
                    process.env['UPLINK_address'] = context.listening.address
                    process.env['UPLINK_port'] = context.listening.port

                    context.tools.spawn notice,

                        arguments: [ref.script]
                        
                        (error, child) -> 

                            #
                            # TODO: handle this error 
                            # 
                            #

                            # 
                            # spawned a realizer, do not callback until its 
                            # notifier has completed the handshake and sent 
                            # the 'realizer::start' event
                            #

                            unless error?

                                wait(

                                    until: -> collection[ref.script]?

                                    -> callback null, collection[ref.script]


                                ).apply null

                            #
                            # TODO: terminate this wait if child exits
                            #       
                            #       * if it existed before the notifier
                            #         accept (eg, failed secret), this
                            #         would wait for ever
                            # 


                            #
                            # temporary (distinguish child output on parent console)
                            #
                            
                            child.stdout.on 'data', (data) -> 

                                lines = data.toString().split '\n'
                                console.log '---------->', line for line in lines


        return callback null, integrations


module.exports = factory
