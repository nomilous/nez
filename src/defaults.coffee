
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
                plex: 

                    logLevel: 0

                    secret: config.get 'secret'

                    #
                    # Uplink to Home Application
                    # 
                    # [nimbal](https://github.com/nomilous/nimbal)
                    # 

                    connect:

                        adaptor: config.get 'adaptor'
                        uri: config.get 'home'

                    #
                    # Downlink to realizers 
                    #

                    listen: 

                        adaptor: config.get 'adaptor'


    SpecRun: (id, tags, callback) -> 

        callback null,

            _realizer:

                class: 'ipso:SpecRun'
                plex: 

                    secret: config.get 'secret'

                    #
                    # uplink to eo:Develop
                    #

                    connect:

                        adaptor: config.get 'adaptor'
                        uri: 'http://localhost:20202' 

                    #
                    # no listen (specrun is leaf)
                    # 

