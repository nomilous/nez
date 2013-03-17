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

            Quick Huh?
            ----------

            For managing an n-tier nested git repository as a replicatable entity.


        """

    huhh: -> 

        console.log """


            Long Huh?
            ---------

            Imagine working on portions of a node based system called AbraCadabra. And 
            this system is comprised of a multitude of many smaller components each 
            distributed as singlarly purposed npm modules.

            You're currently focussed on the completion ofthe next release of the Cadabra 
            feature which relies in having not yet released versions of several other 
            smaller components appropriately installed as ./node_modules for their ease 
            of distribution and open saucy-ness.

            But you cannot install them with the npm install tool because they are not yet 
            released. And additionally you are also want to occasionally commit the odd 
            minor change to some of those sub modules to enable the new features being 
            integrated into AbraCadabra.

            So you have installed git clones of each of those submodules into ./node_modules
            and are having a fair amount of difficulty keeping track of all the repositories 
            that require sync actions.



            The command...
            cd /home/me/git/abra_cadabra && nez-git init

            ...will build a .git_root file that contains a reference to each git repo clone 
            nested within the specified root.



            It contains records per repo as follows...
            PATH,ORIGIN,BRANCH,REF

            ...where PATH is the nested location of the root of each repo and ORIGIN is the 
            origin git repo and BRANCH and REF specify the current git/ref (version) that 
            each repo should be at at in order for the whole to function as a whole.



            Then the command...
            nez-git status

            ...will present the unified status across all nested repositories. 



            Now imagine you're not the only person working on the pending release of 
            AbraCadabra and you've just commited a change into one of the sub modules 
            in a nested git repo effectively creating a situation where another team 
            members pull of your just pushed root module will break their environment 
            unless they also pull the nested submodule repo. 

            Problem is that the submodule repo is .gitignored so git itself has no idea 
            of that nested dependancy change.



            The command...
            nez-git push 


            ...will push all repos that have commits pending and then update that .git_root 
            file with the new BRANCH,REF where changed. And push that too.



            Which then enables the command...
            nez-git pull

            ...to first collect the new .git_root files and then to pull all changes across 
            the entire tree.

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
    .description('Explains briefly the purpose of this tool.')
    .action -> context.huh()

program
    .command('HUH?')
    .description('Explains more fully the purpose of this tool.')
    .action -> context.huhh()

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

