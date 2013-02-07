Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                Object.prototype.expect = ->

                    return unless edges = Specification.getNode(name).edges

                    Specification.create edges,

                        expectation:

                            object: this
                            opts: arguments
