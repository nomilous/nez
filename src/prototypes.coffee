Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                #
                # **Object.expect** 
                # 
                # A globally available property on *any* object that returns a 
                # function for creating Specifications associated with the object 
                # and pushing those Specifications into the `name`d Stack
                #

                return unless typeof Object.expect == 'undefined' 

                Object.defineProperty Object.prototype, 'expect', 

                    get: -> -> 

                        unless typeof arguments[1] == 'undefined' 

                            throw 'Malformed expect config... use Object.expect <config>'

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

            mock: ->

                #
                # **Object.mock** 
                # 
                # As globally available property on Object that returns a 
                # function for creating a mock object and assigning
                # a set of Specifications to the new object.
                # 

                return unless typeof Object.mock == 'undefined' 

                Object.defineProperty Object.prototype, 'mock', 

                    get: -> -> 

                        unless typeof arguments[0] == 'string'

                            throw 'Malformed mock config... use Object.mock \'MockObjectName\', <config>'

                        className = arguments[0]
                        expectations = arguments[1]

                        eval """
                            this.klass = (function() {
                                function #{className}() {}
                                return #{className};
                            })();
                        """

                        @klass.expect expectations if expectations

                        return new @klass



