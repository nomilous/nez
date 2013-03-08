should = require 'should'
Link   = require '../lib/link'
Nez    = require '../lib/nez'
fs     = require 'fs'

describe 'Link', -> 

    it 'enables the tree walker to span files', (linkWasTraversed) ->

        stack = Nez.link()

        #
        # a fake linked file
        #

        swap = fs.readSync    
        fs.readFileSync = -> """

            child = require('../lib/nez').linked 'child'

            child 'node in linked file', (done) ->

        """
         
        #
        # register for edge events
        #

        stack.on 'edge', (placeholder, nodes) ->

            if nodes.from.label == 'node in linked file'

                #
                # pass test on a traverse internal to 
                # the linked file
                #

                fs.readFileSync = swap
                linkWasTraversed()


        #
        # walk into stack and then link
        #

        stack.stacker 'node1', (child) -> 

            child.link 'file/name'

