require 'should'
require 'fing'
Node = require '../lib/node'

describe 'Node', -> 

    it 'is initialized with a label', (done) -> 

        node = new Node 'label'
        node.label.should.equal 'label'
        done()

    it 'is initialized with further properties by name', (done) -> 

        node = new Node 'label',

            class: 'class'
            callback: (next) -> 
            clan: 'Baswenaazhi'

        node.class.should.equal 'class'
        node.callback.fing.args[0].name.should.equal 'next'
        node.clan.should.equal 'Baswenaazhi'
        done()


    it 'has edges', (done) -> 

        node = new Node 'label'
        node.edges.should.be.instanceof Array
        done()

    it 'has hooks', (done) ->

        node = new Node 'label'
        node.hooks.should.be.instanceof Object
        done()