CoffeeScript = require 'coffee-script'

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


        js = CoffeeScript.compile fs.readFileSync(file).toString(), bare: true

        eval js



    fixPath: (fileName) -> 

        #
        # TODO: it may be necessary to fix path
        # TODO: can't just assume .coffee

        "#{fileName}.coffee"
