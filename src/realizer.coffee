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
    # `configuration` To further configure the actions to take when
    # the function is called.
    # 
    # `realization` The callback to fire when the function is called.
    # 

    @createFunction: (name, object, configuration, realization) ->

        key = object.fing.ref + ':' + name

        if typeof @realizers[key] == 'undefined'

            #
            # To support multiple expectations on the same
            # <instance>.functionName / <prototype>.functionName
            # store each realization callback in a stack.
            # 
            # The stack will be popped. 
            # 
            # SIDEEFFECT: Out of order expectations will cause
            #             test failures... (a good thing)
            #

            @realizers[key] = 

                object:       object
                realizations: []
            
            #
            # create the function
            #
            # TODO: temporary replace, prototype if
            # TODO: tailor this function / and how it 
            #       ataches per the configuration

            object[name] = ->

                # 
                # shift from the realization stack
                # to call the realizations back in
                # create order
                #

                object = Realizer.realizers[key].object
                realizerCallback = Realizer.realizers[key].realizations.shift()
                
                realizerCallback 
                   
                    object: object
                    args: arguments



        @realizers[key].realizations.push realization

    
module.exports = Realizer
