should = require 'should'

describe 'nez-git', -> 

    it 'helps with managing multiple nested git repos,', (dammit) ->

        """

            developing along a composite path requiring parallel 
            syncronization with multiple entirely separate but 
            nested repositories...


        """.should.not.equal """


            an infrastructual unmanageablity whose extent suffices to
            induce a confusion impelled nihility of productivity...


        """

        (-> '!!!' && dammit())()
