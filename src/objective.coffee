notice         = require 'notice'
module.exports = (title, opts...) ->

    unless typeof title == 'string'

        throw new Error 'objective(title, opts...) requires title as string'

    options = opts[0] unless typeof opts[0] == 'function'
    fn      = opts[opts.length - 1]

    unless typeof fn == 'function'

        throw new Error 'objective(title, opts...) requires function as last argument'

    notice = notice.create title, (msg, next) -> 

        console.log msg.content
        next()

    notice.event 'start', options || {}

    fn()
