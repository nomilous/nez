test = require('../lib/nez').test


class Example
    constructor: ->
    function2: (agr1, arg2) -> 'RETURN'
    active: -> return false
    function1: -> 

        #
        # only runs function2 if 'beforeAll' re-defined
        # the behaviour of active()
        #

        if @active()

            @function2 'ARG1', 'ARG2'



test 'Example', (as) ->

    
    as 'active', (it) -> 

        expect beforeEach: ->

            Example.expect active: returning: true


        it 'calls function2', (done) ->

            Example.expect function2: as: 'spy', with: 2: 'ARG2'
            (new Example).function1()
            
            test done

    # 
    # 
    # as 'inactive', (It) ->
    # 
    #     It 'does not call function2', (done) ->
    # 
    #         Example.reject 'function2'
    # 
    #   ...maybe
    # 
    #


tree = require('../lib/nez').stacks['0'].tree
console.log JSON.stringify tree, null, 1

#
#
#
# [
#  {
#   "class": "0",
#   "label": "An Example",
#   "edges": [
#    {
#     "class": "to",
#     "label": "verify that",
#     "edges": [
#      {
#       "class": "IT",
#       "label": "builds a tree",
#       "edges": [
#        {
#         "pending": true,
#         "validation": {
#          "expectation": {
#           "realizerName": "function2",         # brain
#           "realizerCall": "createFunction",    # storm
#           "realizerType": "spy",               # realize, ∞
#           "with": {
#            "0": "FAILED EXPECTATION on prototype:Example:4.function2()",
#            "2": "ARG2"
#           }
#          },
#          "realization": {
#           "args": {
#            "0": "ARG1",
#            "1": "ARG2"
#           }
#          }
#         }
#        }
#       ]
#      }
#     ]
#    }
#   ]
#  }
# ]
#
# later... 
#
