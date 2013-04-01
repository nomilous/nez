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

