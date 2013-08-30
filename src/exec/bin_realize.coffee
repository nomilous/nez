program  = require 'commander'
fs       = require 'fs'
coffee   = require 'coffee-script'
phrase   = require 'phrase'
{defer}  = require 'when'
pipeline = require 'when/pipeline'
sequence = require 'when/sequence'
notice   = require 'notice'


 
program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizer]'
program.option '-c, --connect',        'Establish connection to objective', false
program.option '-p, --port  <num>      ', 'Objective port', 10001
program.option '-X, --no-https         ', 'Connect insecurely', false

program.parse process.argv


pipeline( [

    (        ) -> loadRealizer program
    (realizer) -> startRealizer realizer
    (controls) -> runRealizer controls

] ).then( 

    (resolve) -> # console.log RESOLVED: resolve
    (error)  -> 

        process.stderr.write error.toString()
        process.exit error.errno || 100

    (notify)  -> # console.log NOTIFY:   notify

)


runRealizer = ({uplink, token, notice}) ->

    uplink.event 'hello', testing: 'UPLINK'

    token.on 'ready', ({tokens}) -> 
    
        #
        # TEMPORARY: find and run the phrase tree (from root)
        #  

        for path of tokens

            token.run( tokens[path] ).then( 

                (resolve) -> # console.log RESOLVED: resolve
                (reject)  -> console.log REJECTED: reject 
                (notify)  -> 

                                #
                                # TODO: fix: 'this is not a "state"'
                                #

                    if notify.state == 'run::step:failed'

                                            #
                                            # TODO: step.path (including hook steps)
                                            # 

                        console.log notify.step.ref.token.signature, notify.step.ref.text
                        console.log notify.error.message

                    else if notify.state == 'run::complete'

                        console.log notify.progress



            ) if tokens[path].type == 'root'


startRealizer = (realizer) ->

    start = defer()
    sequence( [

        -> startNotifier realizer
        -> startPhrase realizer

    ] ).then(

        (resolve) -> start.resolve 

            uplink: resolve[0]
            token:  resolve[1].token
            notice: resolve[1].notice

        start.reject

    )
    start.promise

startPhrase = ({opts, realizerFn}) ->

    start = defer()
    process.nextTick -> 
    
        recursor = phrase.createRoot opts, (token, notice) ->

            start.resolve token: token, notice: notice
        
        recursor 'realizer', realizerFn
        
    start.promise


startNotifier = ({opts}) -> 
    
    start = defer()
    process.nextTick -> 

        return start.resolve null unless opts.connect?
    
        notice.connect "realizer/#{opts.uuid}", opts, (error, connection) ->

            return start.reject error if error?
            start.resolve connection
        
    start.promise


loadRealizer = (program) -> 
    
    load = defer()
    process.nextTick -> 

        filename = program.args[0]

        unless filename? 
            return load.reject withError 101, 'MISSING_ARG', 'missing realizerFile'

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

        if program.connect
            realizer.connect = 
                transport: if program.https then 'https' else 'http'
                secret: '∫'
                port: program.port

        load.resolve opts: realizer, realizerFn: realzerFn

    load.promise


withError = (errno, code, message) -> 

    error       = new Error message
    error.errno = errno
    error.code  = code
    return error
