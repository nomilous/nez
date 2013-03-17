program = require 'commander'
colors  = require 'colors'
fs      = require 'fs'


context = 

    root: -> 

        program.root || '.'

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
        # PATH,ORIGIN,BRANCH,REF
        #

        controlFile = "#{context.root()}/.git_root"
        controlData = ''

        #
        # In the interests of getting this done as fast as possible
        # i'm making no attempts at cross platform support to allow
        # shortcuts as nearly unacceptable as this here following: 
        # 
        # In short: this is a goodbye to windows users.
        # 
        # 
        # THIS WILL NEED A REWORK WHEN TIME PERMITS
        # 

        exec = require 'exec-sync'

        for repo in exec(

            "find #{context.root()} | grep -e \/.git\/ | grep -oe ^.*\/.git | sort | uniq"

            #
            # find is traversing the entire tree
            # i strongly suspect it can take its
            # own regex and eliminate the need 
            # for the greps 
            #

        ).split('\n')


            path = repo.match(/(.*)\/.git/)[1]

            origin = exec(

                "git --git-dir=#{repo} config --get remote.origin.url"

            )


            branch = context.gitGetBranch repo

            ref = exec(

                "cat #{repo}/#{branch}"

            )

            controlData += "#{path},#{origin},#{branch},#{ref}\n"


        fs.writeFileSync controlFile, controlData
        

    status: -> 

        #
        # report on all changed git repos 
        # per context.root()/.git_root
        #  

        for line in fs.readFileSync("#{context.root()}/.git_root").toString().split '\n'

            continue unless line.length > 0 # empty last line

            parts = line.match /(.*),(.*),(.*),(.*)/

            path   = parts[1]
            origin = parts[2]
            branch = parts[3]
            ref    = parts[4]

            exec = require 'exec-sync'

            try
                
                fs.lstatSync path

            catch error

                console.log "\nMISSING @ repo:#{path}".red
                console.log "run: nez-git --root #{context.root()} pull # (from the git_root)"
                continue

            status = exec "git --git-dir=#{path}/.git --work-tree=#{path}/ status"

            console.log "\nSTATUS @ repo:#{path}".green
            console.log status

    pull: -> 

        #
        # sync (pull) from ORIGIN for all (repos) at PATH(s) not
        # found to be at BRANCH,REF
        # 
        # per context.root()/.git_root
        #

        for line in fs.readFileSync("#{context.root()}/.git_root").toString().split '\n'

            continue unless line.length > 0 # empty last line

            parts = line.match /(.*),(.*),(.*),(.*)/

            path   = parts[1]
            origin = parts[2]
            branch = parts[3]
            ref    = parts[4]


            if context.root() == '.'
            
                workDir = "#{path}"

            else 

                workDir = "#{context.root()}/#{path}"

            console.log "SYNC (pull) @ #{workDir}".green


            #
            # ensure directory present
            #

            try

                fs.lstatSync workDir

            catch error

                if error.code == 'ENOENT'

                    context.shellSync "mkdir -p #{workDir}"

                else 

                    console.log error.red
                    return


            #
            # ensure git clone present
            # 

            try

                fs.lstatSync "#{workDir}/.git"

            catch error

                if error.code == 'ENOENT'

                    context.spawnSync 'git', ['clone', origin, "#{workDir}"]

                else

                    console.log error.red
                    return


            #
            # ensure git clone is on the appropriate branch
            #

            currentBranch = context.gitGetBranch "#{workDir}/.git"

            if branch != currentBranch 

                #
                # this may need some tailoring to support custom gitting
                # paradigms such as git-flow
                #

                context.spawnSync 'git', [
                    "--git-dir=#{workDir}/.git",
                    "--work-tree=#{workDir}",
                    'checkout', 
                    branch.replace 'refs/heads/', ''
                ]


            #
            # git pull all
            #

            #
            # git --work-tree=node_modules/nez/ --git-dir=node_modules/nez/.git pull origin develop
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # fatal: Could not switch to 'node_modules/nez': No such file or directory
            # 
            # test -d node_modules/nez && echo $?
            # 0
            # 
            
            #
            # how to git pull into a repo that is not the current directory?? 
            # 

    push: -> 

        #
        # sync (push) to ORIGIN for all PATH(s) that
        # are pending commit and update each 
        # corrensponding BRANCH,REF
        # 
        # into context.root()/.git_root
        # 

    gitGetBranch: (gitDir) -> 

        branch = context.shellSync(

            "cat #{gitDir}/HEAD"

        ).match(

            /ref: (.*)$/

        )[1]


    shellSync: (command) -> 

        console.log '(run)'.bold, command
        exec = require 'exec-sync'
        exec command

    

    spawnSync: (bin, opts) -> 

        series = require('async').series
        spawn = require('child_process').spawn

        series [ -> 
            
            console.log '(run)'.bold, bin, opts.join ' '
            child = spawn bin, opts
            child.stdout.pipe process.stdout
            child.stderr.pipe process.stderr

        ]



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
    .action -> context.init()

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

