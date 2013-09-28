#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective   = require '../objective/objective'
tools       = require '../tools'
fs          = require 'fs'
mkdirp      = require 'mkdirp'
uuid        = require 'node-uuid'
inflection  = require 'inflection'
coffee      = require 'coffee-script'
{extname, dirname, basename} = require 'path'

class Develop extends Objective

    configure: (@opts, done) ->  

        if @opts.relativePath? and @opts.relativePath != '' 

            console.log 'ERROR: Develop objective must be run in local directory (repo root dir).'
            process.exit 1 unless @opts.relativePath == 'node_modules/mocha/lib'

        @opts.boundry       ||= ['spec']
        @opts.src           ||= {}
        @opts.src.directory ||= 'src'
        @opts.src.match     ||= /\.coffee$/
        @opts.src.out       ||= 'lib'
        @opts.autospawn      ?= true
        @opts.autocompile    ?= true
        @opts.autospec       ?= true
        @opts.autoinit       ?= true

        done()


    defaultObjective: (spec) -> 

        spec.link directory: 'spec'


    #
    # TODO: 
    # 
    # * optional src folder
    # * monitor spec and src and compile appropriately
    # * on change spawn realizer unless already spawned
    # * on create src auto create spec with snippet including uuid
    # * if already spawned instruct to reload and apply changeset
    # * only run changed specs on first run after reload
    #



    startScheduler: (monitor, @jobTokens, @jobEmitter) -> 

        # console.log Develop: startMonitor: opts

        monitor.dirs.add @opts.src.directory, @opts.src.match, 'src'

        monitor.dirs.on 'create', (filename, stats, ref) => 
            return unless ref == 'src'
            @handleCreatedSourceFile filename 


        monitor.dirs.on 'change', (filename, stats, ref, realizer) => 

            if ref == 'src' 

                specFile = @toSpecFilename filename

                return monitor.realizers.get( filename: specFile ).then( 

                    (realizer) => @handleChangedSourceFile filename, realizer
                    (error) => console.log ERROR_GETTING_REALIZER: error

                )

            else @handleChangedSpecFile filename, realizer 


        monitor.dirs.on 'delete', (filename, stats, ref) => 
            return unless ref == 'src'
            @handleDeletedSourceFile filename 


    toSpecFilename: (filename) -> 

        srcDir   = @opts.src.directory
        specDir  = @opts.boundry[0]
        specFile = filename.replace (new RegExp "^#{srcDir}") , specDir
        extName  = extname specFile
        specFile = specFile.replace extName, "_#{specDir}" + extName


    handleDeletedSourceFile: (filename) -> 

        console.log deleted: filename


    handleCreatedSourceFile: (filename) -> 

        return unless @opts.autospec

        specFile = @toSpecFilename filename
        specDir  = dirname specFile

        try return fs.lstatSync specFile
        catch error
            return unless error.errno == 34

        try fs.lstatSync specDir
        catch error 
            if error.errno == 34
                mkdirp.sync specDir

        class_name = basename(filename).replace extname(filename), ''
        humanName  = inflection.titleize class_name
        className  = inflection.classify class_name
        uniqueName = uuid.v1()

        fs.writeFileSync specFile, 

            """
                title: '#{humanName}'
                uuid:  '#{uniqueName}'
                realize: (context, #{className}, should) -> 

            """ 


    handleChangedSourceFile: (filename, {token, notice}) -> 

        return unless @opts.autocompile

        srcDir  = @opts.src.directory
        outFile = filename.replace( (new RegExp "^#{srcDir}") , @opts.src.out).replace extname(filename), '.js'
        outDir  = dirname outFile

        try fs.lstatSync outDir
        catch error
            if error.errno == 34
                mkdirp.sync outDir

        #
        # TODO: consider tea support (perhaps also fruit juice)
        #

        try 
            source   = fs.readFileSync( filename ).toString()
            compiled = coffee.compile source,
                
                bare: true
                header: true
                literate: filename.match(/litcoffee$/)?

            fs.writeFileSync outFile, compiled

        catch error
            
            console.log 'COMPILE ERROR:', error
            return


        specfile = @toSpecFilename filename
        @handleChangedSpecFile specfile, 
            token: token
            notice: notice
            reload = false
        

    handleChangedSpecFile: (filename, {token, notice}, reload = true) -> 

        if reload

            console.log RELOAD_AND_RUN_SPEC: filename

        else

            console.log RUN_SPEC: filename


module.exports = Develop
