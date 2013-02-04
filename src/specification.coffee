Stack       = require './ostack'
Expectation = require './expectation'


module.exports = Specification =


    create: (opts = {}) -> 

        for key of opts

            continue if key == 'xpect' # dodge circular prototype weirdness

            switch key

                when 'expectation'

                    Stack.current().expectations.push(

                        new Expectation opts[key]

                    )



        

