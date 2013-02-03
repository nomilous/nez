Notification = require './notification'

module.exports = Realization = class Realization extends Notification

    #
    # Realization
    # =========== 
    # 
    # * Implements the ability to capure behaviour.
    # * Red Handed.
    # * And store it in a jar.
    # * With carefully punched holes.
    # * For later... (Expectation Validation)
    # 

    constructor: (@object) -> 

    realize: (@functionName, @functionArgs) -> 

