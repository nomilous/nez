should     = require 'should'
ActiveNode = require '../lib/active_node'

describe 'ActiveNode', ->

    context 'async config lookup', -> 

        it 'enables an ENV based config lookup', (done) -> 

            process.env.NODE_ID   = 'ID'
            process.env.NODE_TAGS = 'for extended role matching nodes in a system'

            new ActiveNode 'LABEL'

                _as: (id, tags, callback) -> 

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

    context 'innerValidate()', -> 

        it 'validates the lookupd config', (done) -> 

            swap = ActiveNode.prototype.innerValidate
            ActiveNode.prototype.innerValidate = (config) -> 
                ActiveNode.prototype.innerValidate = swap

                config.should.equal 'EXTERNAL CONFIG'
                done()


            new ActiveNode 'LABEL' 

                _as: (id, tags, callback) -> callback 'EXTERNAL CONFIG'

                ->


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

        it 'requires behaviour definition in config._as', (done) -> 

            try
                new ActiveNode 'LABEL', {}
            catch error
                error.should.match /ActiveNode requires behaviour definition in config._as/
                done()

        it 'requires specified default factory to exist', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'Thing' 
            catch error
                error.should.match /ActiveNode as 'Thing' is not defined/
                done()

        it 'requires injectable as arg3 function', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'Develop'
            catch error
                error.should.match /ActiveNode requires injectable function arg3/
                done()
