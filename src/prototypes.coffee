Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                return unless typeof Object.expect == 'undefined' 

                Object.defineProperty Object.prototype, 'expect', 

                    #
                    # Object.expect is a property that returns a function
                    # for creating Specifications and pushing them into
                    # the named Stack
                    #

                    get: -> -> 

                        return unless edges = Specification.getNode(name).edges

                        if typeof arguments[0] == 'string'

                            configuration      = {}
                            configuration[arguments[0]] = {}

                            edges.push Specification.create this, 

                                expectation: configuration

                        else

                            for key of arguments[0]
                                
                                configuration      = {}
                                configuration[key] = arguments[0][key]
                                
                                #
                                # Specification generation returns pending Confirmations
                                #

                                edges.push Specification.create this, 

                                    expectation: configuration

