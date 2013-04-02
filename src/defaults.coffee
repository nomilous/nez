
#
# TODO: config to load from file
#

config = require('nezcore').config

module.exports = 

    Develop: (id, tags, callback) -> 

        #
        # Develop Objective (default config factory)
        #

        callback 

            _objective:

                class: 'eo:Develop'
                proxy: 

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

        callback

            _objective:

                class: 'ipso:SpecRun'
                proxy: 

                    #
                    # uplink to eo:Develop
                    #

                    connect:

                        adaptor: config.get 'adaptor'
                        uri: 'http://localhost:20202' 

                    #
                    # no listen (specrun is leaf)
                    # 

