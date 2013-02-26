should = require 'should'
Stack  = require '../lib/stack'
Tree   = require '../lib/tree'

stack  = new Stack 'PARENT'
tree   = Tree.create stack


describe 'Tree', -> 

    it 'is assembled by subscription to the stack events'
