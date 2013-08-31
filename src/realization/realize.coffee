fs             = require 'fs'
# {readFileSync} = require 'fs'  # breaks test stub ability
{defer}        = require 'when'
{compile}      = require 'coffee-script'


withError = (errno, code, message) -> 

    error       = new Error message
    error.errno = errno
    error.code  = code
    return error


module.exports.loadRealizer = (params) -> 

    filename = params.filename 
    connect = params.connect
    https = params.https
    port = params.port
    load = defer()

    process.nextTick -> 

        unless filename? then return load.reject withError 101, 'MISSING_ARG', 'missing realizerFile' 

        try realizer = fs.readFileSync filename, 'utf8'
        catch error
            return load.reject error

        try if filename.match /[coffee|litcoffee]$/
            realizer = compile realizer, bare: true
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
                secret: '∫'
                port: port

        load.resolve opts: realizer, realizerFn: realzerFn

    load.promise



# Notice = require 'notice'
# async  = require('also').inject.async
# tools  = require '../tools'
# ipso   = require 'ipso'
# 
# module.exports = (title, optionalOpts, realizerFn) -> 
# 
#     {context, realizerFn} = ipso.validate.apply this, arguments
#     context.tools = tools
# 
#     #
#     # asynchronous config assembly of args for injection:
#     # 
#     #        ipso( context, notice, realizerFn )
#     #
# 
#     realizer = async
# 
#         beforeAll: (done, inject) -> 
# 
#             Notice.connect 'realizer', context, (error, notice) -> 
# 
#                 if error? 
# 
#                     #
#                     # some libs generate errors that are not
#                     # instances of Error ....
#                     #
# 
#                     
#                     return done new Error error unless error instanceof Error # .... spank them!
#                     return done error
# 
#                 #
#                 # notice has an established connection to the objective
#                 # assign arguments and proceed the injection into ipso
#                 #
# 
#                 inject.first[0] = context
#                 inject.first[1] = notice
#                 done()
# 
#         beforeEach: (done, inject) -> 
# 
#             #
#             # activate alternative resolver injection
#             # to prevent `done` being injected into eo 
#             # as arg1
#             # 
#             # TODO: resolve this deferral somewhere
#             # 
# 
#             inject.defer
#             done()
# 
#         error: (error) -> console.log 'Realizer error!', error
# 
#         ipso
# 
# 
#     realizer realizerFn
