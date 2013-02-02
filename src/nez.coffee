class Nez

    @debug: false

    @expectArray: []

    @expectIndex: {}

    @calledArray: []

    @failedArray: []

    @test: (callback) =>

        if Nez.debug 

            console.log '\ntest() runs with:', callback, '\n'

        while @expectArray.length > 0

            expectation = @expectArray.shift()

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

        @calledArray.length = 0
        @failedArray.length = 0
        @expectIndex = {}
        @debug = false

        callback()


class Realization

    constructor: (@functionName) -> 

        

class Expectation

    constructor: (@functionName, @functionArgs, @functionOrig, @obj) -> 

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
        # attach the expectation spy()
        #

        @obj[@functionName] = =>

            if Nez.debug

                console.log '\n', @functionName, '() runs\n'

            #
            # push details of each call to 
            # the spy() into Nez.calledArray
            # 

            call = new Realization @functionName

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
