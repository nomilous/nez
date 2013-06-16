Realizer = require './realizer'
require 'colors'
require 'should'

class Validation

    constructor: (@expectation) ->

        @realization = {}

        call   = @expectation.realizerCall
        name   = @expectation.realizerName
        object = @expectation.on

        Realizer[ call ] name, object, @expectation, (realization) =>

            @realization = realization


    validate: (failedArray) ->

        expected = @expectation.with
        realized = @realization.args

        if typeof expected == 'string'
            expected = 1: expected

        if typeof realized == 'string'
            realized = 0: realized

        
        return unless expected and realized

        description = @description()

        received = {}

        for seq of expected

            #
            # align 0 based realization args
            # to 1 based expectation args
            #

            position = parseInt( seq ) - 1

            if realized[position]

                received[seq] = realized[position]

        expected['0'] = description
        received['0'] = description

        try

            received.should.eql expected

        catch error

            # description =  '\n' + @description().red
            # description += '\nexpected:  ' + JSON.stringify( expected ) + '\n'
            # description += 'received:  ' + JSON.stringify( received ) + '\n'
            # console.log description

            failedArray.push error


    description: () ->

        description = "FAILED EXPECTATION on #{@expectation.on.fing.ref}."

        if @expectation.realizerCall == 'createFunction'

            description += "#{@expectation.realizerName}()"

        else if @expectation.realizerType == 'set'

            description += "#{@expectation.realizerName} (set)"

        else 

            description += "#{@expectation.realizerName} (get)"

        return description



module.exports = Validation
