require('nez').realize 'GeoStay', (GeoStay, test, context,   should) -> 

    #
    # - injected npm module 'should'
    # - will inject local classes from lib|app (if,,, CamelCased)
    # 

    context 'in CONTEXT', (does) ->
                            #
                            #
          ###################
          #
          #
        does 'an EXPECTATION', (done) ->

            should.exist 'test here'

            #
            # These are all the same function,
            # a 'stack' builder
            # 
            (done == does == context).should.equal true


            test done
