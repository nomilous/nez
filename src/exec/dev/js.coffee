Coffee = require './coffee' 

module.exports = class Js extends Coffee

    start: ->

        @watch 'spec', @onchange
        @watch 'app',  @onchange


# 
# not to offend anybody sticking to their javascript guns, 
# 
#    but:
# 
#        i find <this> deeply amuzing 
# 
