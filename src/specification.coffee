require 'fing'

module.exports = class Specification

    @objects: {}

    @create: (object, expectation) ->

        @objects[ object.fing.ref ] ||=

            #
            # firsttime initialize storage for this
            # object and it's expectations 
            #

            object: object
            expectations: []

        @objects[ object.fing.ref ].expectations.push expectation
