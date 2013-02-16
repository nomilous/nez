fs = require 'fs'

module.exports = class Dev

    #
    # developer environment
    #

    constructor: (@program) ->

        #
        # is there a ./lib or an ./app dir
        #

        try 
            libdir = fs.lstatSync './lib'

        try
            appdir = fs.lstatSync './app'

        #
        # not initially going to support the complexitites
        # of having both.
        #

        if libdir and libdir.isDirectory

            app = './lib'

        if appdir and appdir.isDirectory

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

