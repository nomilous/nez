title: 'submarine test'
uuid:  '00000000-0000-0000-0000-000000000002'

realize: (it, ThePeriscope, should) -> 

    require 'should'

    console.log FIRST_WALK: 'submarine test'

    before each: (done) ->
        
        @periscope = periscope: {} # new ThePeriscope
        done()

    it 'can peek topside', (done) -> 

        #
        # 1. Create expectations
        # 

        @periscope.should.eql telescope: 'microscope'

                    #
                    # throws [AssertionError]
                    # 
                    # TODO: fix 'it still waited for timeout' 
                    #


        # console.log @periscope
        # @periscope.must receive

        #     riseToTheSurface: (distance) ->

        #         distance.should.be.an.instanceof Number
        #         return true

        #     openTheEye: ->  

        #         return true


        #
        # 2. Perform action that should meet the expectations
        #

        #@periscope.peekTopside()


        #
        # 3. Evaluate extent of success
        #

        done()

    

        #
        # 4. Watch this very beautiful video 
        # 
        #    http://vimeo.com/68238929
        # 


