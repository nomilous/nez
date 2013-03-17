program = require 'commander'
colors  = require 'colors'

program.option '-r, --root [root]',  'Specify the root repo. Default ./'

program.parse process.argv

module.exports = NezGit = 

    exec: () -> 


    scan: (rootRepoDir) -> 

        #
        # assemble rootRepoDir/.git_root file with
        # 
        # PATH,ORIGIN,HEAD
        #

    status: (rootRepoDir) -> 

        #
        # report on all changed git repos 
        # per rootRepoDir/.git_root
        #  

    pull: (rootRepoDir) -> 

        #
        # sync (pull) from ORIGIN for all (repos) at PATH(s) not
        # found to be at HEAD
        # 
        # per rootRepoDir/.git_root
        #


    push: (rootRepoDir) -> 

        #
        # sync (push) to ORIGIN for all PATH(s) that
        # are pending commit and update each 
        # corrensponding HEAD
        # 
        # into rootRepoDir/.git_root
        # 

