Expectation = require './expectation'

module.exports = Specification =

    getNode: (stackName) ->

        #
        # late require, need the stack as it currently is
        #

        return require('./nez').stacks[stackName].node
        

    create: (array, opts = {}) -> 

        for key of opts

            continue if key == 'expect'

            switch key

                when 'expectation'

                    array.push(

                        new Expectation opts[key]

                    )

