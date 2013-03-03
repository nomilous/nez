module.exports = class Node

    constructor: (label, opts = {}) ->

        for property of opts

            this[property] = opts[property]

        @label = label

        @hooks = {}

        @edges = []
