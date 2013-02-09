require 'fing'

class Realizer

    # 
    # Realizer creates or overrides functions or properties
    # on a specified object / prototype ('class')
    # 

    @realizers: {

        #
        # It keeps a reference to each created override
        #

    }

    #
    # **createFunction()** Create a function expectation.
    # 
    # `name` The name of the function
    # 
    # `object` The object / 'class' to create the fuction on.
    # 
    # `realization` The callback to fire when the function is called.
    # 
    # `configuration` To further configure the actions to take when
    # the function is called.
    # 

    @createFunction: (name, object, configuration, realization) ->

        #
        #
        #

        key = object.fing.ref + ':' + name

        if typeof @realizers[key] == 'undefined'

            @realizers[key] = {}


        #realization = @realizers

        object[name] = -> realization()




    
module.exports = Realizer
