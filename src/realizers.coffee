#
# attached realizers collection
#

Notice     = require 'notice'
wait       = require('also').schedule.wait


factory    = (context, notice, callback) -> 

    collection  = {}
    startedAt   = {}

    children    = {}
    checksum    = {}
    spawnedAt   = {}
    startedLag  = {}
    pids        = {}

    Notice.listen 'realizers', context, (error, Realizers) ->

        Realizers.use (msg, next) -> 

            #
            # message pipeline middleware, inbound from realizers
            #

            switch msg.context.title

                when 'realizer::start'

                    # 
                    # remote realizer has established connection
                    # ------------------------------------------
                    # 
                    # * store reference the message 'reply' pipeline in 
                    #   the collection
                    # 

                    properties = msg.properties
                    id = properties.id || properties.script
                    reply  = msg.reply
                    collection[id] = reply

                    startedAt[id]  = Date.now()
                    startedLag[id] = startedAt[id] - spawnedAt[id] if spawnedAt[id]?
                    delete spawnedAt[id]
                    

            next()

        return callback error if error?

        return callback null, interface = 

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

                interface.get ref, (error, realizer) -> 

                    if error? 

                        return notice.event.bad 'missing or broken realizer',

                            description: ref.id
                            error: error

                    #
                    # start task at realizer
                    #

                    realizer.task title, ref
                    

            #
            # realizers.get( ref, callback ) 
            # 
            # calls back with a reference to the
            # realizer specified in ref.id
            # 

            get: (ref, callback) -> 

                unless ref? and ref.id? 

                    throw new Error 'realizers.get(ref, callback) requires ref.id as the realizer id'

                #
                # realizer already present
                # 

                if collection[ref.id]?

                    return callback null, collection[ref.id] unless (

                        children[ref.id]? and checksum[ref.id] != context.tools.checksum.file ref.id

                    )

                    #
                    # if it was spawned locally, respawn if the 
                    # script checksum changed
                    #

                    #
                    # TODO: make this an event, for deployment switching, later.
                    #

                    child = children[ref.id]
                    pid   = child.pid
                    child.kill()

                    delete collection[ref.id]
                    delete children[ref.id]
                    delete spawnedAt[ref.id]
                    delete pids[pid]
                    

                
                #
                # SPECIAL CASE
                # ------------
                # 
                # A local realizer can be spawned if ref defines the script to run
                # 
                # * script name is used as reference id in the collection
                # * map from pid to id is kept in pids
                #

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


                #
                # error if spawned but not yet connected
                #

                if spawnedAt[ref.script]?

                    return notice.info 'already waiting for realizer', 
                        description: "pid:#{children[ref.script].pid}, script:#{ref.script}"
                    


                context.tools.spawn notice,

                    arguments: [ref.script]

                    exit: (pid) -> 

                        #
                        # realizer exited - remove ref from collection
                        #

                        id = pids[pid]
                        delete collection[id]
                        delete children[id]
                        delete spawnedAt[id]
                        delete pids[pid]
                        

        
                    (error, child) -> 

                        # 
                        # spawned the realizer as child
                        # pid maps kid to id/(script)
                        #


                        pids[child.pid] = ref.script
                        children[ref.script] = child

                        unless error?

                            spawnedAt[ref.script] = Date.now()
                            checksum[ref.script]  = context.tools.checksum.file ref.script

                            #
                            # do not callback until its 
                            # notifier has completed the handshake and sent 
                            # the 'realizer::start' event
                            #

                            wait(

                                until: -> 

                                    #
                                    # is the realizer connected yet?
                                    #

                                    collection[ref.script]? or

                                    #
                                    # did it already exit (before connecting)
                                    #

                                    not pids[child.pid]?


                                -> 

                                    #
                                    # okgood, got it!
                                    # 

                                    unless collection[ref.script]?

                                        return callback new Error 'realizer exited before connecting'

                                    callback null, collection[ref.script]


                            ).apply null


                        #
                        # temporary (distinguish child output on parent console)
                        #
                        
                        child.stdout.on 'data', (data) -> 

                            lines = data.toString().split '\n'
                            console.log '---------->', line for line in lines


module.exports = factory
