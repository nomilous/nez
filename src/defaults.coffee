
#
# TODO: config to load from file
#

config = require('nezcore').config

module.exports = 

    Develop: (id, tags, callback) -> 

        #
        # Develop Objective (default config factory)
        #

        callback null,

            _objective:

                class: 'eo:Develop'

            _plex: 

                secret: 'SEEKRIT'


    SpecRun: (id, tags, callback) -> 

        callback null,

            _realizer:

                class: 'ipso:SpecRun'

            _plex: 

                secret: 'SEEKRIT'

