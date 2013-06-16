module.exports = (title, opts...) ->

    unless typeof title == 'string'

        throw new Error 'objective(title, opts...) requires title as string'

    fn = opts[opts.length - 1]

    unless typeof fn == 'function'

        throw new Error 'objective(title, opts...) requires function as last argument'

    fn()
