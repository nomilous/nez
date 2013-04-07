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

