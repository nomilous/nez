Realizer = require './realizer'
require 'should'

class Validation

    constructor: (@expectation) ->

        @realization = {}

        call   = @expectation.realizerCall
        name   = @expectation.realizerName
        object = @expectation.on

        Realizer[ call ] name, object, @expectation, (realization) =>

            @realization = realization


    validate: ->

        expected = @expectation.with
        realized = @realization.args

        return unless expected and realized

        received = {}

        for seq of expected

            continue if seq == 'expect'

            #
            # align 0 based realization args
            # to 1 based expectation args
            #

            position = parseInt( seq ) - 1

            if realized[position]

                received[seq] = realized[position]


        expected.should.eql received


module.exports = Validation
