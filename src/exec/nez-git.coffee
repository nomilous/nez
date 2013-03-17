program = require 'commander'
colors  = require 'colors'

context = 

    root: -> 

        program.root || './'

    huh: ->

        #
        # So there's a commandline helper that describes a pile 
        # switches, options and commands...
        # 
        # But what does it do? (overall purpose)
        # 

        console.log """



        """

    init: -> 

        #
        # assemble context.root()/.git_root file with
        # 
        # PATH,ORIGIN,HEAD
        #

    status: -> 

        #
        # report on all changed git repos 
        # per context.root()/.git_root
        #  

        console.log 'running status from root:', context.root()

    pull: -> 

        #
        # sync (pull) from ORIGIN for all (repos) at PATH(s) not
        # found to be at HEAD
        # 
        # per context.root()/.git_root
        #


    push: -> 

        #
        # sync (push) to ORIGIN for all PATH(s) that
        # are pending commit and update each 
        # corrensponding HEAD
        # 
        # into context.root()/.git_root
        # 


program.option '-r, --root [root]',  'Specify the root repo. Default ./'

program
    .command('huh?')
    .description('Explains more fully the purpose of this tool.')
    .action -> context.huh()

program
    .command('init')
    .description('Assemble the initial .git_root control file into [root]')
    .action -> context.pull()

program
    .command('status')
    .description('Git status across all nested git repos')
    .action -> context.status()

program
    .command('pull')
    .description('Git pull across all nested git repos not up-to-date with .git_root')
    .action -> context.pull()

program
    .command('push')
    .description('Git push across all nested git repos pending commits and update .git_root')
    .action -> context.push()

program.parse process.argv

