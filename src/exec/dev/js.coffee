Coffee = require './coffee' 

module.exports = class Js extends Coffee

    start: ->

        @watch 'spec', @onchange
        @watch 'app',  @onchange


    # toSpec: (file) ->

    #     #
    #     # convert eg ./app/thing.js to ./spec/thing_spec.[??]
    #     #

    #     console.log 'pending js convert to specfilename ', file
    #     'specfile'





# 
# not to offend anybody sticking to their javascript guns, 
# 
#    but:
# 
#        i find <this> deeply amuzing 
# 
