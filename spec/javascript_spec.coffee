should = require 'should'

describe 'javascript', ->

    YES = it
    NO = xit


    YES 'using an object prototype as hash key works', (done) ->


        class Test1
        class Test2

        hash = {}

        hash[Test1] = 1
        hash[Test1].should.equal 1

        hash[Test1] = 2
        hash[Test1].should.equal 2

        hash[Test2] = 1
        hash[Test2].should.equal 1

        done()



    NO 'using and object instance as hash key works', (done) ->

        class Test1

        hash = {}

        one = new Test1()
        two = new Test1()

        hash[one] = 1
        hash[two] = 2

        hash[one].should.equal 1
        hash[two].should.equal 2

        done()
        


    NO 'using and object instance as hash key work if they have differing property values', (done) ->

        class Test1
            property1: 'value'

        hash = {}


        one = new Test1()
        one.property1 = 'V1'
        one.property2 = 'V2'

        two = new Test1()

        hash[one] = 1
        hash[two] = 2

        hash[one].should.equal 1
        hash[two].should.equal 2


        done()



    NO 'is it possible to get the pointer address of an object to enable distinguishing one from another', (done) ->


        true.should.equal false
        done()



    YES 'does the presence of prototype distinguish instance from its prototype definition', (done) ->


        class Test

        should.exist Test.prototype
        should.not.exist (new Test()).prototype
        done()



    YES 'is it possible to assign a unique identity to an object or class', (done) ->

        seq = 0

        Object.defineProperty Object.prototype, '_id',

            get: ->

                if typeof @prototype == 'undefined'

                    @__id ||= "object:#{@constructor.name}:#{++seq}"

                else

                    @__id ||= "class:#{@name}:#{++seq}"


        class Test1

        Test1._id.should.equal 'class:Test1:1'
        Test1._id.should.equal 'class:Test1:1'
        Test1._id.should.equal 'class:Test1:1'



        test10 = new Test1
        test10._id.should.equal 'object:Test1:2'
        test10._id.should.equal 'object:Test1:2'

        test11 = new Test1 # new instance, new id
        test11._id.should.equal 'object:Test1:3'
        test11._id.should.equal 'object:Test1:3'



        class Test2
        Test2._id.should.equal 'class:Test2:4'
        Test2._id.should.equal 'class:Test2:4'

        class Test2 # redefined class, new id..
        Test2._id.should.equal 'class:Test2:5'
        Test2._id.should.equal 'class:Test2:5'



        test20 = new Test1
        test20._id.should.equal 'object:Test1:6'
        test20._id.should.equal 'object:Test1:6'

        test21 = new Test2
        test21._id.should.equal 'object:Test2:7'
        test21._id.should.equal 'object:Test2:7'

        done()
















