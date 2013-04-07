module.exports = class Node

    constructor: (label, properties = {}) ->

        for property of properties

            this[property] = properties[property]

        @label = label
