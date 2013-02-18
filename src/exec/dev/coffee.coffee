fs    = require 'fs'
hound = require 'hound'

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

                @compile file, => @test @toSpec file

            when 'app'

                @test @toSpec file


    compile: (file, after) ->

        console.log 'pending compile:', file
        after()



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


    test: (file) -> 

        console.log 'pending run spec:', file

