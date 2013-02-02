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

                if expectation.functionArgs.with

                    expectedArgs = expectation.functionArgs.with

                    #
                    # .with specified args to match
                    #

                    if Nez.debug

                        console.log "EXPECTED:", expectedArgs, typeof expectedArgs

                    
                    if typeof expectedArgs == 'object'

                        expectation.failed = 'PENDING SUPPORT'
                        Nez.failedArray.push expectation


                    else if expectedArgs != expectation.realization.args[0]

                        expectation.failed = 'Argument Mismatch'
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

        if Nez.debug

            console.log '\nnew realization', @functionName, 'with:', @args, '\n'

        

class Expectation

    constructor: (@functionName, @functionArgs, @functionOrig, @obj) -> 

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
