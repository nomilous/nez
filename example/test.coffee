test  = require('../lib/nez').test


class Example
    constructor: ->
    function1: -> @function2 'ARG1', 'ARG2'
    function2: (agr1, arg2) -> 'RETURN'


test 'An Example', (to) ->

    to 'verify that', (it) ->

        it 'builds a tree', (done) ->

            Example.expect function2: as: 'spy', with: 2: 'ARG2'
            (new Example).function1()
            done()


tree = require('../lib/nez').stacks['0'].tree
console.log JSON.stringify tree, null, 1