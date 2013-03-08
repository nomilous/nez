Tree   = require '../lib/tree'
stack  = require('../lib/nez').link()
tree   = Tree.create stack

describe 'Tree', -> 

    it 'is assembled by subscription to the stack events', (done) ->

        stack.stacker 'Outer Node', (THAT) -> 

            THAT 'has inner node1'

            THAT 'has inner node2', (AND) ->

                AND 'proceeds deeper', -> 

                    done()

# 
#   undefined root     ------>  PARENT Outer Node
# PARENT Outer Node    ------>  THAT has inner node1
# THAT has inner node1 ------>  PARENT Outer Node
# PARENT Outer Node    ------>  THAT has inner node2
# THAT has inner node2 ------>  AND proceeds deeper
# ․AND proceeds deeper ------>  THAT has inner node2
# THAT has inner node2 ------>  PARENT Outer Node
# PARENT Outer Node    ------>  undefined root
#

