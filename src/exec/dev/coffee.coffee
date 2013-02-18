child_process = require 'child_process'
hound         = require 'hound'
fs            = require 'fs'

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

        console.log "running config:", @config

        @watch 'spec', @onchange
        @watch 'src', @onchange

    done: (file) ->

        console.log 'done: ', file
        

    watch: (what, onchange) ->

        console.log 'Watching: ', @config[what]
        watcher = hound.watch @config[what]

        watcher.on 'change', (file, stats) => 

            @onchange what, file, stats


    onchange: (what, file, stats) -> 

        #console.log 'changed %s file: %s', what, file

        switch what

            when 'spec'

                @test file

            when 'src'

                @compile file, => @test @toSpec(file), => @done(file)

            when 'app'

                @test @toSpec file


    compile: (file, after) ->

        console.log 'compile:', file

        outDir = file.match(/^.*\//)[0].replace(

            new RegExp "^\.\/#{@config.src[2..-1]}"
            "#{@config.app}"

        )
        options = [ '-c', '-b', '-o', outDir, file ]
        builder = child_process.spawn './node_modules/.bin/coffee', options
        builder.stdout.pipe process.stdout
        builder.stderr.pipe process.stderr
        builder.on 'exit', -> after()


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

        # .replace(
        #     /\.js$/
        #     "_spec.js"
        # )


    test: (file, after) -> 

        console.log "test: ", file

        test_runner = child_process.spawn './node_modules/.bin/mocha', [
            '--colors',
            '--compilers', 
            'coffee:coffee-script', 
            file
        ]
        test_runner.stdout.pipe process.stdout
        test_runner.stderr.pipe process.stderr
        test_runner.on 'exit', -> after()

