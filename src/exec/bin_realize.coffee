program  = require 'commander'
fs       = require 'fs'
coffee   = require 'coffee-script'
phrase   = require 'phrase'
{defer}  = require 'when'
pipeline = require 'when/pipeline'

 
program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizer]'
program.parse process.argv


pipeline( [

    (        ) -> loadRealizer program
    (realizer) -> startRealizer realizer

] ).then( 

    (resolve) -> console.log RESOLVED: resolve
    (error)  -> 

        process.stderr.write error.toString()
        process.exit error.errno || 1

    (notify)  -> console.log NOTIFY:   notify

)


startRealizer = ({opts, realizerFn}) ->

    recursor = phrase.createRoot opts, (token) ->
        
        token.on 'ready', ({tokens}) -> 
        
            #
            # TEMPORARY: find and run the phrase tree (from root)
            #  

            for path of tokens

                token.run( tokens[path] ).then( 

                    (resolve) -> console.log RESOLVED: resolve
                    (reject)  -> console.log REJECTED: reject 
                    (notify)  -> console.log NOTIFY:   notify 

                ) if tokens[path].type == 'root'

    recursor 'realizer', realizerFn



    



loadRealizer = (program) -> 
    
    load = defer()
    process.nextTick -> 

        filename = program.args[0]

        unless filename? 
            return load.reject withError 100, 'MISSING_ARG', 'missing realizerFile'

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
        load.resolve opts: realizer, realizerFn: realzerFn

    load.promise


withError = (errno, code, description) -> 

    error       = new Error description
    error.errno = errno
    error.code  = code
    return error
