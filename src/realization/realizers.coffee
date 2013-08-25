#
# Realizers Collection
# ====================
#

exports.createCollection = ( ƒ ) -> 

    new ( try 

        #
        # Alternate Controller
        # --------------------
        # 
        # * opts.controller can define node module
        #

        if ƒ.controller? then require ƒ.controller

        #
        # * or the default
        #

        else require './controller'

    catch π

        #
        # EXIT 4
        # ------
        # 
        # * the specified controller was not installed
        #

        try delete ƒ.listen.secret
        try delete ƒ.listening
        console.log OPTS: ƒ, ERROR: π
        process.exit 4

    ) ƒ

