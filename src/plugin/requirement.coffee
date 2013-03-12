module.exports = Requirement = 

    configure: (stacker, config) -> 
    edge: (placeholder, nodes) ->
    hup: ->

    handles: ['requirement']
    requirement: (node) -> 

        meta = node.label

        node.label = meta.title
        node.class = 'requirement'
        node.requirement = meta

    matches: ['as']
    as: (value) -> Requirement.requirement
