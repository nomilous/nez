Stack       = require './ostack'
Expectation = require './expectation'

module.exports = Specification =

    create: (array, opts = {}) -> 

        for key of opts

            continue if key == 'xpect' # dodge circular prototype weirdness

            switch key

                when 'expectation'

                    array.push(

                        new Expectation opts[key]

                    )

