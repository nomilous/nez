test  = require('../lib/nez').test


class Example
    constructor: ->
    function1: -> @function2 'ARG1', 'ARG2'
    function2: (agr1, arg2) -> 'RETURN'


test 'An Example', (to) ->

    expect this: {}

    to 'verify that', (IT) ->

        IT 'builds a tree', (done) ->

            Example.expect function2: as: 'spy', with: 2: 'ARG2'
            (new Example).function1()
            
            test done

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
