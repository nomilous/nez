require 'should'

class Nez

    @debug: false

    @expectArray: []

    @expectIndex: {}

    @calledArray: []

    @failedArray: []

    @test: (callback) =>

        #
        # Perform expectation validation
        #

        if Nez.debug 

            console.log '\ntest() runs with:', callback, '\n'


        @failedArray.length = 0


        #
        # For each call assembled in the calledArray
        #

        while Nez.calledArray.length > 0

            realization = Nez.calledArray.shift()

            functionName = realization.functionName

            if Nez.debug 

                console.log '\ntest() found that function:', functionName, 'was called\n'

            #
            # attach realization details to the original
            # expectation
            # 

            location = Nez.expectIndex[functionName].shift()

            if location == undefined

                #
                # more than the intended number of calls was made
                # to an expectated function
                #

                realization.failed = 'Was Called Too Often'

                Nez.failedArray.push realization

                continue


            expectation = Nez.expectArray[location]



            #
            # it should not be possible for multiple realizations
            # against the same expectation
            # 
            #
            # if expectation.realization
            #     console.log 'expectation already realized:\n', expectation, '\nnew realization:', realization
            # 

            expectation.realization = realization

            if Nez.debug

                console.log '\ntest() updated expectation :', expectation, '\n'


        while Nez.expectArray.length > 0

            #
            # place unrealized expectations into the failed array
            #

            expectation = Nez.expectArray.shift()

            if expectation.realization

                if expectation.functionArgs

                    expectedArgs = expectation.functionArgs

                    #
                    # .with specified args to match
                    #

                    if Nez.debug

                        console.log "EXPECTED:", expectedArgs, typeof expectedArgs

                    try

                        #
                        # TODO: loop through each arg
                        # TODO: support only specified ie `with: 5:{'sixth':'only'}`
                        # 

                        expectedArgs.should.eql expectation.realization.args

                        # if typeof expectedArgs == 'object'

                        #     expectedArgs.should.eql expectation.realization.args

                        # else

                        #     expectedArgs.should.equal expectation.realization.args

                    catch error

                        expectation.failed = 'Argument Mismatch'
                        expectation.exception = error
                        Nez.failedArray.push expectation

            else

                expectation.failed = 'Was Not Called'
                Nez.failedArray.push expectation 


            #
            # remove/restore the original function
            #

            expectation.obj[ expectation.functionName ] = expectation.functionOrig

        #
        # Apparently setting Array.length 
        # zero deletes all elements 
        # 
        # (hmm?) 
        #

        if Nez.debug

            console.log '\ntest() found the following unrealized:', Nez.failedArray, '\n'


        @calledArray.length = 0
        @expectIndex = {}
        @debug = false

        callback()



class Realization

    constructor: (@functionName, @args) -> 

        @type = 'Realization'

        # #
        # # Marshal args into an array
        # #

        # @args = []

        # for arg in args

        #     @args.push arg

        # #
        # # If there is only one arg
        # #

        # @args = @args[0] if @args.length == 1

        if Nez.debug

            console.log '\nnew realization', @functionName, 'with:', @args, '\n'

        

class Expectation

    constructor: (@functionName, @expectationParams, @functionOrig, @obj) -> 

        @type = 'Expectation'

        if Nez.debug

            console.log '\nnew expectation', @functionName, '\n'

        #
        # BUG1 I dont understand why expectCall() itself is
        #      registering through here as an expectation
        # 
        #      This is probably not the best way to stop it.
        # 

        return if @functionName == 'expectCall'

        args = @expectationParams.with

        switch typeof args

            when 'number', 'string' then @functionArgs = 0 : args

            when 'function' then @functionArgs = 0 : args

            when 'object'

                if args instanceof Array

                    @functionArgs = 0 : args

                else 

                    #
                    # verify args of the form:
                    # 
                    # 0:'thing', 1:{thing:''}, 2:['also']
                    #

                    # console.log 'huh? args are:', args

                    for key of args

                        if typeof key != 'number'

                            #
                            # BUG2 - for key of {'0':{}, '1':{}}
                            #        is producing a third key,
                            # 
                            # console.log 'KEY::::', key
                            # 
                            #    KEY:::: 0
                            #    KEY:::: 1
                            #    KEY:::: expectCall
                            # 
                            # ummm?
                            # continue if key == 'expectCall'
                            # BUG 'seems' to have gone? 

                            #
                            # found non number key, assume a 
                            # single argument expectation
                            # 

                            @functionArgs = 0 : args

                            break

                    @functionArgs = args

                    # console.log "ARG:", args[key]


            else console.log "MISSING TYPE:", typeof args


        #
        # store the call details of a possible expectation match  
        #

        @realization = null

        #
        # attach the expectation spy()
        #

        @obj[@functionName] = =>

            if Nez.debug

                console.log '\n', @functionName, '() runs\n'

            #
            # push details of each call to 
            # the spy() into Nez.calledArray
            # 

            call = new Realization @functionName, arguments

            Nez.calledArray.push call



Object.prototype.expectCall = (xpect) -> 

    if Nez.debug 

        console.log '\n', 'expectCall() to:', xpect, '\n'

    for fName of xpect

        #
        # create expectation
        #

        x = new Expectation fName, xpect[fName], this[fName], this

        if x.functionName == 'expectCall'

            #
            # BUG1 I dont understand why expectCall() itself is
            #      registering through here as an expectation
            # 
            #      This is probably not the best way to stop it.
            # 

            continue


        Nez.expectArray.push x
        
        Nez.expectIndex[fName] ||= []

        Nez.expectIndex[fName].push Nez.expectArray.length - 1

        if Nez.debug

            console.log '\nexpectIndex with: ', Nez.expectIndex, '\n'


module.exports = Nez
