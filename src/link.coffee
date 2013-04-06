CoffeeScript = require 'coffee-script'
colors       = require 'colors'

module.exports = link = 

    linker: (opts) -> 

        if typeof opts == 'string'

            return link.fileLink opts


    fileLink: (fileName) -> 

        fs = require 'fs'

        if fileName.match /^\//

            #
            # absolute path
            #

            file = fileName

        else

            file = link.fixPath(fileName) 



        try

            source = fs.readFileSync(file).toString()

            js = CoffeeScript.compile source, bare: true

        catch error

            #
            # Coffee parser failed
            # 

            if match = error.message.match /Parse error on line (\d*)/

                line = match[1]
                link.showError file, source, parseInt(line), error.message


        eval js



    fixPath: (fileName) -> 

        #
        # TODO: it may be necessary to fix path
        # TODO: can't just assume .coffee
        # 

        "#{fileName}.coffee"


    showError: (fileName, fileContents, lineNumber, message) ->

        #
        # display the offending line in context
        #
        
        console.log "\nIN file: #{fileName.bold}"
        console.log "ERROR:   #{message.red}\n"
        lines = fileContents.split '\n'
        start = lineNumber - 5
        for num in [1..10]
            lineNum = start + num++
            line = lines[lineNum]
            if lineNum + 1 == lineNumber
                line = lines[lineNum].bold.red
            console.log "#{lineNum + 1}  ", line
        console.log '\n'



