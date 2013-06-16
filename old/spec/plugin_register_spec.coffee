should  = require 'should'
Plugins = require '../lib/plugin_register'

describe 'PluginRegister.handler()', -> 

    before ->

        @plugin = plugin = 

            #
            # plugin handlers are firstly matched from class
            # 
            # ie. 'Story' in the following example
            # 
            #    Story 'label', (Task) -> 
            #
            # 

            handles: ['Story']
            Story: (node) -> 
                node.handledBy = 'Story1'

            #
            # plugin handlers are secondly matched from label metatags
            # 
            # ie. 'majorAxis' in the following example
            # 
            #    ellipse2337 { majorAxis: 20, minorAxis: 3 }, (behaviour) ->
            # 
            #

            matches: ['majorAxis']
            majorAxis: (value) -> 
                return plugin.largeEllipse if value >= 20
                return plugin.smallEllipse
            largeEllipse: (node) -> 
                node.area  = Math.PI * 0.25 * node.label.majorAxis * node.label.minorAxis
                node.label = 'large ellipse' 


        Plugins.register @plugin


    it 'passes nodes to plugin handlerFn matched by class', (done) ->

        node = class: 'Story'
        Plugins.handle node
        
        node.handledBy.should.equal 'Story1'
        done()


    it 'it passes nodes to plugin handlers matched by label metatag', (done) -> 

        node = label:
            majorAxis: 20
            minorAxis: 2

        Plugins.handle node

        node.label.should.equal 'large ellipse'
        node.area.should.equal   31.41592653589793
        done()


    it 'passes nodes to matche plugins in register sequence', (done) -> 

        Plugins.register 
            handles: ['Story']
            Story: (node) -> 
                node.handledBy += 'Story2'
            matches: []
        node = class: 'Story'

        Plugins.handle( node ).handledBy.should.equal 'Story1Story2'
        done()


