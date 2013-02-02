class Nez

    @debug: false

    @expectArray: []

    @calledArray: []

    @test: (callback) =>

        if @debug 

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

        callback()


class Realization

    constructor: (@functionName) -> 

        

class Expectation

    constructor: (@functionName, @functionArgs, @functionOrig, @obj) -> 

        #
        # attach the expectation spy()
        #

        @obj[@functionName] = =>

            if @debug 

                console.log '\n', @functionName, '() runs\n'

            #
            # push details of each call to 
            # the spy() into Nez.calledArray
            # 

            call = new Realization @functionName

            Nez.calledArray.push call



Object.prototype.expectCall = (xpect) -> 

    if @debug 

        console.log '\n', 'expectCall() runs with:', xpect, '\n'

    for fName of xpect

        #
        # create expectation
        #

        x = new Expectation fName, xpect[fName], this[fName], this

        Nez.expectArray.push x


module.exports = Nez
