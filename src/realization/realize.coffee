fs             = require 'fs'
# {readFileSync} = require 'fs'  # breaks test stub ability
{defer}        = require 'when'
coffee         = require 'coffee-script'
{hostname}     = require 'os'
notice         = require 'notice'
phrase         = require 'phrase'


withError = (errno, code, message) -> 

    error       = new Error message
    error.errno = errno
    error.code  = code
    return error

module.exports.runRealizer = ({uplink, opts, realizerFn}) -> 

    running = defer()

    #
    # uplink     - connection to the objective (if -c)
    # opts       - realizer title, uuid and such
    # realizerFn - realizer phrase function
    # 

    #
    # Initialize Realizer PhraseTree
    # ------------------------------
    #
    # * create the PhraseTree with objective uplink as message bus
    # 

    opts.notice    = uplink
    phraseRecursor = phrase.createRoot opts, (token) -> 


    init = -> 

        #
        # * nested init() loads the realizer phrase tree 
        # * the uplink to the objective is also the phrase tree 
        #   message bus, so all phrase assembly messages are received 
        #   by the local graph assembler and whatever middlewares are 
        #   listening at the objective
        # * this phraseRecursor returns a promise
        # 

        return phraseRecursor 'realizer', realizerFn



    uplink.use (msg, next) -> 

        ### realizer middleware 1 ###

        switch msg.direction

            when 'out' 
                switch msg.event

                    when 'connect', 'reconnect', 'ready', 'error'
                        msg.uuid     = opts.uuid
                        msg.pid      = process.pid
                        msg.hostname = hostname()

                        console.log SENDING:   msg.context, msg
                        next()

                    else
                        console.log SENDING:   msg.context, msg
                        next()


            when 'in' 

                console.log RECEIVING: msg.context, msg

                switch msg.event

                    when 'reject'

                        error = new Error msg.event
                        error.errno = 101 # TODO: formalize (others are scattered about)
                        error[key] = msg[key] for key of msg
                        running.reject error

                    when 'init'

                        init().then(

                            (result) -> uplink.event.good 'ready'  # , result
                            (error)  -> 

                                payload = error: error
                                try payload.stack = error.stack
                                uplink.event.bad 'error', payload

                            #(notify) -> console.log PHRASE_INIT_NOTIFY: notify

                        )

                    else next()




    

    return running.promise

    #
    # TEMPORARY
    # ---------
    # 
    # * call the 'first walk' into the realizerFn to load the tree
    # 
    #    This sends all phrase recursion payloads 
    #    over to the objective.
    # 
    # 
    # phraseRecursor 'realizer', realizerFn
    #



module.exports.startNotifier = ({opts, realizerFn}) -> 
    
    start = defer()
    process.nextTick -> 

        unless opts.connect?

            #
            # offline mode
            # ------------
            # 
            # * starts standalone notifier, still "called" uplink
            #

            return start.resolve 

                uplink:     notice.create "#{opts.uuid}"
                opts:       opts
                realizerFn: realizerFn 

        #
        # uplinked
        # --------
        # 
        # * notifier connectes to objective per connect config present
        #   in the realizer or on the commandline
        #
        # * all opts except for connect are included as client context
        # 

        origin = {}
        for key of opts
            continue if key == 'connect'
            origin[key] = opts[key]
        opts.origin = origin
    
        notice.connect "#{opts.uuid}", opts, (error, uplink) ->

            return start.reject error if error?
            
            start.resolve 

                uplink: uplink
                opts: opts
                realizerFn: realizerFn
        
    start.promise

module.exports.loadRealizer = (params = {}) -> 

    filename = params.filename 
    connect = params.connect
    https = params.https
    port = params.port
    secret = process.env.SECRET
    load = defer()

    process.nextTick -> 

        unless filename? then return load.reject withError 101, 'MISSING_ARG', 'missing realizerFile' 

        try realizer = fs.readFileSync filename, 'utf8'
        catch error
            return load.reject error

        try if filename.match /[coffee|litcoffee]$/
            realizer = coffee.compile realizer, bare: true
        catch error

            #  
            #  { [SyntaxError: unexpected STRING]
            #    location: 
            #     { first_line: 27,
            #       first_column: 12,
            #       last_line: 27,
            #       last_column: 29 } }
            #  

            return load.reject error


        try realizer = eval realizer

        catch error

            #
            # [ReferenceError: f is not defined]
            # 
            # TODO: surely an eval has more than this on error?
            #

            return load.reject error



        realzerFn = realizer.realize || (Signature) -> Signature 'Title', (end) -> end()
        delete realizer.realize

        if connect?
            realizer.connect = 
                transport: if https then 'https' else 'http'
                secret: secret
                port: port

        load.resolve opts: realizer, realizerFn: realzerFn

    load.promise
