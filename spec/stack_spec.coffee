should = require 'should' 
Stack  = require '../src/stack'

describe 'Stack', -> 

    it 'can create multiple stacks', (done) -> 

        Stack.create 'stack1'
        Stack.create 'stack2'

        Stack.get('stack1').className.should.equal 'Stack'
        Stack.get('stack1').className.should.equal 'Stack'
        Stack.get('stack1').should.eql Stack.stacks['stack1']
        Stack.get('stack2').should.eql Stack.stacks['stack2']
        done()


    describe 'create()', -> 

        it 'returns a function', (done) -> 

            fn = Stack.create 'stack1'

            fn.should.be.an.instanceof Function
            done()

