Specification = require './specification' 

module.exports = 

    object:

        set:

            expect: (name) ->

                console.log 'bind Object.prototype.expect() to', name

                Object.prototype.expect = ->

                    return unless edges = Stack.stacks[name].edges



            expectSet: (name) ->

                console.log 'bind Object.prototype.expectSet() to', name

                Object.prototype.expectSet = ->

            expectGet: (name) ->

                console.log 'bind Object.prototype.expectGet() to', name

                Object.prototype.expectGet = ->
