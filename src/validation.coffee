Realizer = require './realizer'

class Validation

    constructor: (@expectation) ->

        @realization = {}

        call   = @expectation.realizerCall
        name   = @expectation.realizerName
        object = @expectation.on

        Realizer[ call ] name, object, @expectation, (realization) =>

            @realization = realization


module.exports = Validation
