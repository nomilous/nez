should     = require 'should'
ActiveNode = require '../lib/active_node'
Defaults   = require '../lib/defaults'
Eo         = require 'eo'

describe 'ActiveNode', ->
    
    #
    # stop from startings
    #

    ActiveNode.prototype.start = (config) ->

    context 'async config lookup', -> 

        it 'enables an ENV based config lookup', (done) -> 

            process.env.NODE_ID   = 'ID'
            process.env.NODE_TAGS = 'for extended role matching nodes in a system'

            new ActiveNode 'LABEL'

                as: (id, tags, callback) -> 

                    id.should.equal 'ID'
                    tags.should.eql [

                        'for' 
                        'extended' 
                        'role' 
                        'matching' 
                        'nodes' 
                        'in' 
                        'a' 
                        'system'

                    ]
                    done()

                -> 

        it 'enables an ENV based configurer', (done) -> 

            Eo.fakeConfigure = (id, tags, callback) -> callback 'CONFIG'

            ActiveNode.prototype.start = (config) -> 

                ActiveNode.prototype.start = (config) ->
                delete process.env.NODE_AS
                config.should.equal 'CONFIG'
                done()

            process.env.NODE_AS = 'eo:fakeConfigure'

            new ActiveNode 'LABEL', {}, ->


    context 'innerValidate()', -> 

        it 'validates the lookupd config', (done) -> 

            swap = ActiveNode.prototype.innerValidate
            ActiveNode.prototype.innerValidate = (config) -> 
                ActiveNode.prototype.innerValidate = swap
                config.should.equal 'EXTERNAL CONFIG'

                throw '古老的中国谚语'
                

            try
                new ActiveNode 'LABEL' 
                    as: (id, tags, callback) -> callback 'EXTERNAL CONFIG'
                    ->

            catch corrective
            
                corrective.should.match /古老的中国谚语/
                done()


    context 'outerValidate()', ->  

        it 'requires label as arg1 string', (done) -> 

            try  
                new ActiveNode
            catch error
                error.should.match /ActiveNode requires 'label' string as arg1/
                done()

        it 'requires config as arg2 object', (done) -> 

            try
                new ActiveNode 'LABEL'
            catch error
                error.should.match /ActiveNode requires config hash as arg2/
                done()

        it 'defaults objective plugin to "Develop"', (done) -> 

            Defaults['Develop'] = (id, tags, callback) -> callback 'Develop'

            ActiveNode.prototype.start = (config) -> 

                config.should.equal 'Develop'
                done()

            new ActiveNode 'LABEL', {}, -> 
            

        it 'attempts to load objective plugin configure from module', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'thing', ->
            catch error
                error.should.match /Cannot find module 'thing'/
                done()

        it 'can load objective plugin configure from "module:object"', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'thing:function', ->
            catch error
                error.should.match /Cannot find module 'thing'/
                done()

        xit 'requires injectable as arg3 function', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'Develop'
            catch error
                error.should.match /ActiveNode requires injectable function arg3/
                done()
