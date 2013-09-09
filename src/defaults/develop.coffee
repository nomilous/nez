#
# Develop (Objective)
# ===================
# 
# Runs the objective loop as a development environment.
# 

Objective = require '../objective/objective'
Realize   = require '../realization/realize'

class Develop extends Objective

    startMonitor: (opts, monitor, @jobTokens, @jobEmitter) -> 

        # console.log Develop: startMonitor: opts

        monitor.dirs.add opts.src.directory, opts.src.match, 'src'

        monitor.dirs.on 'create', (filename, stats, ref) => 
            return unless ref == 'src'
            @handleCreatedSourceFile filename 

        monitor.dirs.on 'change', (filename, stats, ref, realizer) => 
            if ref == 'src' then @handleChangedSourceFile filename
            else @handleChangedSpecFile filename, realizer

        monitor.dirs.on 'delete', (filename, stats, ref) => 
            return unless ref == 'src'
            @handleDeletedSourceFile filename 



    #
    # TODO: 
    # 
    # * optional src folder
    # * monitor spec and src and compile appropriately
    # * on change spawn realizer unless already spawned
    # * on create src auto create spec with snippet including uuid
    # * if already spawned instruct to reload and apply changeset
    # * only run changed specs on first run after reload
    #

    onBoundryAssemble: (opts, callback) -> 

        Realize.loadRealizer( opts ).then( 

            (realizer) -> 

                #
                # convert to phrase format
                #

                phrase =
                    title: realizer.opts.title
                    control: realizer.opts
                    fn: realizer.realizerFn

                delete phrase.control.title

                callback null, phrase

            (error) -> callback error

        )


    configure: (opts, done) ->  

        opts.boundry = ['spec', 'test'] unless opts.boundry?

        #
        # it is assumed the develop objective will be run in the repo directory
        #

        opts.src         ||= {}
        opts.src.directory = 'src' unless opts.src.directory?
        opts.src.match     = /\.coffee$/ unless opts.src.match?

        opts.autospawn     = true

        done()


    defaultObjective: (spec) -> 

        spec.link directory: 'spec'


    handleCreatedSourceFile: (filename) -> 

        console.log created: filename


    handleChangedSourceFile: (filename) -> 

        console.log changed: filename


    handleDeletedSourceFile: (filename) -> 

        console.log deleted: filename


    handleChangedSpecFile: (filename, realizer) -> 

        console.log 
            SPEC_CHANGE: filename
            REALIZER: realizer
        #console.log @jobTokens


module.exports = Develop
