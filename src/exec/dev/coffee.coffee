child_process = require 'child_process'
colors        = require 'colors'
hound         = require 'hound'
path          = require 'path'
fs            = require 'fs'
i             = require 'inflection'

module.exports = class Coffee

    #
    # developer environment
    #

    constructor: (@program) ->

        #
        # is there a ./lib or an ./app dir
        #

        try 
            dir = fs.lstatSync './lib'
            if dir.isDirectory

                app = './lib'

        try
            dir = fs.lstatSync './app'
            if dir.isDirectory
                if app
                    console.log 'Appologies. Supports ./app OR ./lib dirs. Not both.'
                    return

                app = './app'


        @config = 

            spec: @program.specdir || './spec'
            src:  @program.srcdir  || './src'
            app:  app              || './app'


    start: ->

        console.log "(config)", @config

        #
        # do nothing (And say why) if srcdir and specdir
        # are not present
        # 
        missing = []
        for parameter in ['spec', 'src']
            unless fs.existsSync @config[parameter]
                missing.push @config[parameter]

        if missing.length > 0
            console.log 'Expected directory(ies):'.red.bold, missing.toString()
            return




        @watch 'spec', @onchange
        @watch 'src', @onchange

    done: (file) ->

        console.log '(done)', file
        

    watch: (what, onchange) ->

        console.log '(watch)', @config[what]
        watcher = hound.watch @config[what]

        watcher.on 'change', (file, stats) => 

            @onchange what, file, stats


    onchange: (what, file, stats) -> 

        #console.log 'changed %s file: %s', what, file

        switch what

            when 'spec'

                @test file, ->

            when 'src'

                @compile file, => @test @toSpec(file), => @done(file)

            when 'app'

                @test @toSpec file


    compile: (file, after) ->

        outDir = file.match(/^.*\//)[0].replace(

            new RegExp "^\.\/#{@config.src[2..-1]}"
            "#{@config.app}"

        )

        compiler = @getCompiler()
        console.log '(compile)', file
        options = [ '-c', '-b', '-o', outDir, file ]
        builder = child_process.spawn compiler, options
        builder.stdout.pipe process.stdout
        builder.stderr.pipe process.stderr
        builder.on 'exit', -> after()

    getCompiler: ->

        #
        # use locally installed coffee-script
        # TODO: use global one if installed

        nezRoot = __dirname.match(/^(.*\/nez\/)(.*)/)[1]
        return nezRoot + 'node_modules/.bin/coffee'


    toSpec: (file) -> 

        #
        # convert eg ./src/thing.coffee to ./spec/thing_spec.coffee
        #

        specFile = file.replace(

            new RegExp "^\.\/#{@config.src[2..-1]}"
            "#{@config.spec}"

        ).replace(

            /\.coffee$/
            "_spec.coffee"

        )

    test: (file, after) -> 

        console.log "(spec)", file

        unless fs.existsSync file

            @noSpecFile file, after

        else

            test_runner = @getCompiler()

            # test_runner = child_process.spawn './node_modules/.bin/mocha', [
            #     '--colors',
            #     '--compilers', 
            #     'coffee:coffee-script', 
            #     file
            # ]

            test_runner = child_process.spawn @getCompiler(), [file]
            test_runner.stdout.pipe process.stdout
            test_runner.stderr.pipe process.stderr
            test_runner.on 'exit', -> after()


    noSpecFile: (file, after) ->

        parts = @klast file

        return if @program.noautospec

        #
        # Automatically generate missing spec snippet
        #

        unless fs.existsSync parts.path

            @mkdirMinusP parts.path

        fs.writeFile parts.path + parts.specname, """

        #{parts.classname} = require '#{parts.require}'

        describe '#{parts.classname}', ->


        """, (err) ->

            if err

                console.log 'failed to create file:', file
                return

            console.log 'generated:', file
            after()
 


    klast: (file) -> 

        parts = file.match /^(.*\/)(.*)_spec\..*$/

        rpath = ''

        for part in file.split('/')[2..-1]

            rpath += '../'

        rpath = (rpath += parts[1]).replace(

            "./#{@config.spec}", "#{@config.app}"

        )

        return {

            path:      parts[1]
            specname:  "#{parts[2]}_spec.coffee"
            filename:  "#{parts[2]}.coffee"
            require:   "#{rpath}#{parts[2]}"
            classname: i.classify parts[2]

        }


    mkdirMinusP: (path) -> 

        minusP = ''

        for dir in path.split '/'

            continue if dir == ''

            minusP += dir + '/'

            unless fs.existsSync minusP

                console.log "mkdir:", minusP

                fs.mkdirSync minusP




