module.exports = 

    create: (code, message) -> 

        error = new Error message
        error.code = code
        error
