Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: ->

                return unless typeof Object.expect == 'undefined' 

                Object.defineProperty Object.prototype, 'expect', 

                    get: -> 

                        #
                        # **Object.expect( `config` )** 
                        # 
                        # A globally available property on *any* object that returns a 
                        # `function()` for creating Specifications associated with the object 
                        # and pushing those Specifications into the named Stack
                        #

                        (config) -> 


                            unless typeof arguments[1] == 'undefined' 

                                throw 'Malformed expectation config... use <instance|ClassName>.expect <config>'
                            

                            expectation = config


                            #
                            # Marshal default config from 'string'
                            #

                            if typeof config == 'string'

                                expectation         = {}
                                expectation[config] = {}


                            #
                            # create a new realizable Expectation on `this` via the Specification
                            # interface
                            #

                            Specification.create

                                interface: this

                                config: expectation

                                realizer: 'PLACEHOLDER'

                                


            mock: ->

                return unless typeof Object.mock == 'undefined' 

                Object.defineProperty Object.prototype, 'mock', 

                    get: -> 

                        #
                        # **Object.mock( `className`, `config` )** 
                        # 
                        # As globally available property on Object that returns a 
                        # function for creating a mock object and assigning
                        # a set of Specifications to the new object.
                        # 

                        (className, config) -> 

                            unless typeof className == 'string'

                                throw 'Malformed mock config... use Object.mock \'MockObjectName\', <config>'


                            eval """
                                this.klass = (function() {
                                    function #{className}() {}
                                    return #{className};
                                })();
                            """

                            @klass.expect config if config

                            return new @klass



