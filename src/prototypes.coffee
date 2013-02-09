Specification = require './ospecification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                Object.prototype.expect = ->

                    return unless edges = Specification.getNode(name).edges

                    edges.push Specification.create 

                        expectation:

                            object: this
                            opts: arguments[0]
