require 'fing'
Node = require './node'

module.exports = class Stack

    className: 'Stack'

    constructor: (@name) -> 

        @stack   = []
        @node    = new Node 'root'


        #
        # TODO: move the tree out of here
        # TODO: add an event emitter, the tree builder can subscribe
        #

        @walker  = @tree = @node.edges


    stacker: (label, callback) => 

        @push arguments


    push: (args) -> 

        label    = args[0]
        callback = args[1]  # TODO: as last arg
        klass    = @pendingClass || @name
 
        if callback and callback.fing.args.length > 0
        
            @pendingClass = callback.fing.args[0].name 


        if label

            @node = new Node label,

                callback: callback
                class:    klass

            @stack.push @node
            @walker.push @node
            @walker = @node.edges

            try

                @node.callback @stacker if callback

            catch error

                #
                # Ignore assertion errors while assembling 
                # the test stack.
                # 
                # validator() re-executes entire stack from 
                # each 'leaf'
                # 

                throw error unless error.name = 'AssertionError'
            

            node = @stack.pop()

            if @stack.length > 0

                @node   = @stack[@stack.length - 1]
                @walker = @node.edges

            @pendingClass = @node.class


    validator: (done) =>

        console.log "validate"

        testString = ''
        leafNode   = undefined

        for node in @stack

            testString += "#{node.class.bold} #{node.label} "
            leafNode = node
            
        console.log testString
        
        done()

