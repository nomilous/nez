notice         = require 'notice'
module.exports = (title, opts...) ->

    unless typeof title == 'string'
        throw new Error 'objective(title, opts...) requires title as string'

    fn  = opts[opts.length - 1]
    unless typeof fn == 'function'
        throw new Error 'objective(title, opts...) requires function as last argument'


    #
    # create messenger source
    #

    notice = notice.create title, (msg, next) -> 
        console.log msg.content
        next()


    #
    # pending eo
    #

    options = title: title
    unless typeof opts[0] == 'function'
        options[key] = opts[0][key] for key of opts[0]

    
    notice.event 'objective::start', objective: options

    fn()
