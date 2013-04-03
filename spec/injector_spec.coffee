# should   = require 'should'
# Injector = require '../lib/injector'

# describe 'Injector', ->


#     it 'call the function passed as last argument', (thisFunctionWasCalled) -> 

#         Injector.realize 'Node', optional: 'thing', ->

#             thisFunctionWasCalled()


#     it 'injects the prototype of the specified ClassName as arg1', (done) ->  

#         Injector.realize 'Node', (Node) -> 

#             Node.should.equal require('../lib/node')
#             done()

#     it 'initializes the test stack', (done) ->

#         Injector.realize 'Node', (Node) -> 

#             require('../lib/nez').stack.name.should.equal 'Node'
#             done()

#     it 'injects the validator as arg2', (done) -> 

#         Injector.realize 'Node', (Node, validate) -> 

#             validate.should.equal require('../lib/nez').stack.validator
#             done()

#     it 'injects the test stack assembler as arg3', (done) -> 

#         Injector.realize 'Node', (Node, validate, context) -> 

#             context.should.equal require('../lib/nez').stack.stacker
#             done()


#     it 'injects all further args (if downcased) as third party modules/services', (done) -> 

#        Injector.realize 'Node', (Node, validate, context, hound:watch, docco) -> 

#             watch.should.equal require('hound').watch
#             docco.should.equal require 'docco'
#             done()

#     it 'injects all further args (if CamelCase) as local modules', (done) ->

#         Injector.realize 'Node', (Node, validate, context, hound, Stack) ->

#             console.log Stack.should.eql require '../lib/stack'
#             done()

