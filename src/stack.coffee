expectations = []

module.exports = 
    
    #
    # Going to need to push and pop specSets to be able
    # to set expectations in nested describe before and 
    # beforeEach hooks
    # 
    # Later...
    # 
    # For now, just making sure no interface changes will
    # be necessary when i get there.
    # 
    # 

    current: -> 

        return {

            expectations: expectations

        }
