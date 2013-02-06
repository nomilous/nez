module.exports = class Node

    className: 'Node'

    constructor: (@label, opts = {}) ->

        for property of opts

            this[property] = opts[property]

        @edges = []
