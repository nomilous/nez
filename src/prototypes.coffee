Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                Object.prototype.expect = ->

                    #
                    # pushes pending expectation Confirmations into the
                    # current node of the tree 
                    #

                    return unless edges = Specification.getNode(name).edges

                    if typeof arguments[0] == 'string'

                        configuration      = {}
                        configuration[arguments[0]] = {}

                        edges.push Specification.create this, 

                            expectation: configuration

                    else

                        for key of arguments[0]

                            continue if key == 'expect'
                            
                            configuration      = {}
                            configuration[key] = arguments[0][key]
                            
                            #
                            # Specification generation returns pending Confirmations
                            #

                            edges.push Specification.create this, 

                                expectation: configuration

                                
