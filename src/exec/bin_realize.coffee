program = require 'commander'
fs      = require 'fs'
coffee  = require 'coffee-script'
phrase  = require 'phrase'

 
program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizerFile]'
program.parse process.argv


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



loadRealizer = (opts) -> 

    unless opts.filename? 
        console.log 'missing realizerFile'
        process.exit 1

    realizer = fs.readFileSync opts.filename, 'utf8'
    if opts.filename.match /[coffee|litcoffee]$/
        realizer = coffee.compile realizer, bare: true

    realizer = eval realizer
    realzerFn = realizer.realize || (Signature) -> Signature 'Title', (end) -> end()
    delete realizer.realize
    return opts: realizer, realizerFn: realzerFn


try
    
    startRealizer loadRealizer filename: program.args[0]

catch error
    
    console.log error.message
    process.exit 2
