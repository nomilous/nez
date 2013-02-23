Inflection = require 'inflection'

module.exports = Injector = 

    inject: -> 

        for key of arguments

            #
            # function is the last argument
            #

            func = arguments[key]





        klass  = arguments[0]

        # for key of arguments

        #     #
        #     # function is the last argument
        #     #

        #     func = arguments[key]



        module = Injector.findModule klass
        # pusher = Nez.stacks['0'].pusher
        # validator = pusher

        # skip = 0
        # service = []
        # for arg in func.fing.args

        #     continue unless ++skip > 3
        #     service.push require arg.name

        # #
        # # dont know 'if it's possible' / 'how' to tack an array 
        # # onto the end of a function call such that the elements
        # # are appended eachly instead of allfully
        # #
        # # and googling such an abstract notion will take
        # # more time than i want to allocate right now
        # # 
        # # so...
        # # 

        func require(module) #, pusher, validator, service[0], service[1], service[2], service[3], service[4], service[5], service[6], service[7], service[8], service[9], service[10], service[11], service[12], service[13], service[14], service[15], service[16], service[17], service[18], service[19], service[20], service[21], service[22]  # i suspect that'll suffice... :)

