program  = require 'commander'
fs       = require 'fs'
phrase   = require 'phrase'
{defer}  = require 'when'
pipeline = require 'when/pipeline'
sequence = require 'when/sequence'
notice   = require 'notice'
Realize  = require '../realization/realize'


 
program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizer]'
program.option '-c, --connect',        'Establish connection to objective', false
program.option '-p, --port  <num>      ', 'Objective port', 10001
program.option '-X, --no-https         ', 'Connect insecurely', false

program.parse process.argv


pipeline( [

    (        ) -> marshalArgs program
    ( params ) -> Realize.loadRealizer params
    (realizer) -> startNotifier realizer
    (controls) -> runRealizer controls

] ).then( 

    (resolve) -> # console.log RESOLVED: resolve
    (error)  -> 

        process.stderr.write error.toString()
        process.exit error.errno || 100

    (notify)  -> # console.log NOTIFY:   notify

)


runRealizer = ({uplink, opts, realizerFn}) -> 

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


    uplink.event 'realizer::connect', 

        uuid: opts.uuid
        pid:  process.pid


    uplink.use (msg, next) -> 

        switch msg.context.direction

            when 'out' then console.log SENDING:   msg.context, msg
            when 'in'  then console.log RECEIVING: msg.context, msg

        next()


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


startNotifier = ({opts, realizerFn}) -> 
    
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

        context = {}
        for key of opts
            continue if key == 'connect'
            context[key] = opts[key]
        opts.context = context
    
        notice.connect "#{opts.uuid}", opts, (error, uplink) ->

            return start.reject error if error?
            
            start.resolve 

                uplink: uplink
                opts: opts
                realizerFn: realizerFn
        
    start.promise


marshalArgs = (program) -> 

    marshal = defer()
    process.nextTick -> 

        marshal.resolve 

            filename: program.args[0]
            connect:  program.connect
            https:    program.https
            port:     program.port

    marshal.promise


withError = (errno, code, message) -> 

    error       = new Error message
    error.errno = errno
    error.code  = code
    return error
