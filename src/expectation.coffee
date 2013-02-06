Realization = require './realization'

module.exports = class Expectation extends Realization

    className: 'Expectation'

    constructor: (opts = {}) -> 

        console.log 'new Expectation', opts
