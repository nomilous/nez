#
# Realizers Collection
# ====================
#

exports.createCollection = ( π ) -> 

    new ( try 

        #
        # Alternate Controller
        # --------------------
        # 
        # * opts.controller can define node module
        #

        if π.controller? then require π.controller

        #
        # * or the default
        #

        else require './controller'

    catch error

        #
        # EXIT 4
        # ------
        # 
        # * the specified controller was not installed
        #

        try delete π.listen.secret
        try delete π.listening
        console.log OPTS: π, ERROR: error
        process.exit 4

    ) π

