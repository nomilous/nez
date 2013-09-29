program  = require 'commander'
fs       = require 'fs'
{defer}  = require 'when'
pipeline = require 'when/pipeline'
sequence = require 'when/sequence'


Realize  = require '../realization/realize'


program.version JSON.parse( fs.readFileSync __dirname + '/../../package.json', 'utf8' ).version
program.usage '[options] [realizer]'
#program.option '-x, --no-connect',        'Run without connecting to objective', false
program.option '-p, --port  <num>      ', 'Connect to objective at port'
program.option '-X, --no-https         ', 'Connect insecurely', false

program.parse process.argv

pipeline( [

    (        ) -> marshalArgs program
    ( params ) -> Realize.loadRealizer params
    (realizer) -> Realize.startNotifier realizer
    (controls) -> Realize.runRealizer controls

] ).then( 

    (resolve) -> # console.log RESOLVED: resolve
    (error)  -> 

        process.stderr.write error.toString()
        process.exit error.errno || 100

    (notify)  -> # console.log NOTIFY:   notify

)

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
