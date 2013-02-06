require 'should'
Specification = require '../src/specification'
Stack         = require '../src/ostack'

describe 'Specification', -> 

    it 'is a Repeatably Confirmable Expectation Realization Validation', 

        (Lorry, Red) -> 

            "Lorry, Yello #{ Lorry() }, Red Lolly"


    it """ 

        encapsulates this
        -----------------


        Expectation + Realization + Validation ?= Confirmation


        where
        -----

        Expectation  = required functionality
        Realization  = implemented functionality
        Validation   = evaluation of Realization against Expectation / running of tests
        Confirmation = passing of tests


    """, ->


    it 'provides an interface to create', (done) -> 

        Specification.create.should.be.an.instanceof Function
        done()


    it 'pushes new expectations into the provided array', (done) -> 

        array = []
        Specification.create array, expectation: {}

        array.length.should.equal 1
        array[0].className.should.equal 'Expectation'
        done()

