should     = require 'should'
ActiveNode = require '../lib/active_node'
Defaults   = require '../lib/defaults'
Plex       = require 'plex'
Eo         = require 'eo'

describe 'ActiveNode', ->
    
    start = ActiveNode.prototype.start
    #ActiveNode.prototype.start = (config) -> 'stop from starting'

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

            Eo.fakeConfigure = (id, tags, callback) -> callback null, 'CONFIG'

            ActiveNode.prototype.start = (config) -> 

                ActiveNode.prototype.start = start
                delete process.env.NODE_AS
                config.should.equal 'CONFIG'
                done()

            process.env.NODE_AS = 'eo:fakeConfigure'

            new ActiveNode 'LABEL', {}, ->

    describe 'has a runtime', -> 

        it 'with a logger', (done) -> 

            ActiveNode.prototype.start = (config) -> 

                ActiveNode.prototype.start = start
                done()

            should.exist new ActiveNode( 

                'LABEL', as: 'Develop', ->

            ).config._runtime.logger
    
    
    it 'allows specified services to be injected', (done) ->

        #ActiveNode.prototype.start = start

        new ActiveNode 'LABEL'

            description: ''

            as: (id, tags, configCallback) -> 

                configCallback null, _objective: class: 'eo:Develop'
            
            with: [

                #
                # inject done() as fun()
                #

                done

                #
                # inject 'should' as could
                #

                'should'

                #
                # inject Objective
                #

                'eo:Objective'

                #
                # inject a function as such()
                #

                -> '' 


            ], (stacks, fun, could, Be, such) -> 

                stacks 'of', -> 

                    fun.should.equal done 
                    could.should.equal should
                    Be.should.equal require('eo').Objective
                    could.exist such fun()


    context 'innerValidate()', -> 

        it 'validates the lookupd config', (done) -> 

            swap = ActiveNode.prototype.innerValidate
            ActiveNode.prototype.innerValidate = (config) -> 
                ActiveNode.prototype.innerValidate = swap
                config.should.equal 'EXTERNAL CONFIG'

                throw '古老的中国谚语'
                

            try
                new ActiveNode 'LABEL' 
                    as: (id, tags, callback) -> callback null, 'EXTERNAL CONFIG'
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
            

        it 'attempts to load objective plugin configurer from module', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'thing', ->
            catch error
                error.should.match /Cannot find module 'thing'/
                done()

        it 'can load objective plugin configurer from "module:object"', (done) -> 

            try
                new ActiveNode 'LABEL', as: 'thing:function', ->
            catch error
                error.should.match /Cannot find module 'thing'/
                done()
