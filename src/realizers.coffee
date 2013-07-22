#
# attached realizers collection
#

Notice     = require 'notice'
wait       = require('also').schedule.wait
defer      = require('when').defer
tasks      = require('does').tasks

factory    = (context, notice, callback) -> 
    
    collection  = {}
    startedAt   = {}


    children    = {}
    checksum    = {}
    spawnedAt   = {}
    startedLag  = {}
    pids        = {}

    Notice.listen 'realizers', context, (error, Realizer) -> 

        #
        # handle attaching realizer
        # 

        Realizer.use (msg, next) -> 

            switch msg.context.title

                when 'realizer::register'

                    # 
                    # remote realizer has established connection
                    # ------------------------------------------
                    # 
                    # * create instance of task to encapsulate the realizer
                    # 

                    opts        = msg.properties
                    uuid        = opts.uuid
                    opts.notice = msg.reply

                    tasks.task opts, (error, task) -> 

                            #
                            # ignoring error (task collection is not yet persistable)
                            #

                            collection[uuid] = task
                            startedAt[uuid]  = Date.now()
                            startedLag[uuid] = startedAt[uuid] - spawnedAt[uuid] if spawnedAt[uuid]?
                            delete spawnedAt[uuid]

            next()

        return callback error if error?

        return callback null, api = 

            #
            # realizers.start( opts )
            # 
            # opts.uuid - uuid of the realizer to start
            # 

            start: (opts) -> 

                running = defer()

                api.get opts, (error, realizer) -> 

                    console.log REALIZER: realizer

                    if error? 

                        running.reject error

                        return notice.event.bad 'missing or broken realizer',

                            realizer: opts.uuid
                            script: opts.script
                            error: error

                
                    realizer.start( opts ).then running.resolve, running.reject, running.notify

                return running.promise


            #
            # realizers.get( ref, callback ) 
            # 
            # calls back with a reference to the
            # realizer specified in ref.id
            # 

            get: (ref, callback) -> 

                unless ref? and ref.uuid? 

                    throw new Error 'realizers.get(ref, callback) requires ref.uuid as the realizer uuid'

                #
                # realizer already present
                # 

                if collection[ref.uuid]?

                    return callback null, collection[ref.uuid] unless (

                        #
                        # if it was spawned locally, respawn if the 
                        # script checksum changed
                        #

                        children[ref.uuid]? and checksum[ref.uuid] != context.tools.checksum.file ref.script

                    )

                    child = children[ref.uuid]
                    pid   = child.pid
                    child.kill()

                    delete collection[ref.uuid]
                    delete children[ref.uuid]
                    delete spawnedAt[ref.uuid]
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

                if spawnedAt[ref.uuid]?

                    return notice.info 'already waiting for realizer', 
                        description: "pid:#{children[ref.uuid].pid}, script:#{ref.script}"

                context.tools.spawn notice,

                    arguments: [ref.script]

                    exit: (pid) -> 

                        #
                        # realizer exited - remove ref from collection
                        #

                        uuid = pids[pid]
                        delete collection[uuid]
                        delete children[uuid]
                        delete spawnedAt[uuid]
                        delete pids[pid]
                        

        
                    (error, child) -> 

                        # 
                        # spawned the realizer as child
                        # pid maps kid to id/(script)
                        #

                        pids[child.pid] = ref.script
                        children[ref.uuid] = child

                        unless error?

                            spawnedAt[ref.uuid] = Date.now()
                            checksum[ref.uuid]  = context.tools.checksum.file ref.script

                            #
                            # do not callback until its 
                            # notifier has completed the handshake and sent 
                            # the 'realizer::register' event
                            #

                            wait(

                                until: -> 

                                    #
                                    # is the realizer connected yet?
                                    #

                                    collection[ref.uuid]? or

                                    #
                                    # did it already exit (before connecting)
                                    #

                                    not pids[child.pid]?


                                -> 

                                    #
                                    # okgood, got it!
                                    # 

                                    unless collection[ref.uuid]?

                                        return callback new Error 'realizer exited before connecting'

                                    callback null, collection[ref.uuid]


                            ).apply null


                        #
                        # temporary (distinguish child output on parent console)
                        #
                        
                        child.stdout.on 'data', (data) -> 

                            lines = data.toString().split '\n'
                            console.log '---------->', line for line in lines


module.exports = factory
