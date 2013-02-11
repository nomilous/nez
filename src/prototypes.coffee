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

                    for key of arguments[0]

                        configuration      = {}
                        configuration[key] = arguments[0][key]
                        
                        #
                        # Specification generation returns pending Confirmations
                        #

                        edges.push Specification.create this, configuration

                            
