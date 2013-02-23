### Due Homage

[RSpec](http://rspec.info/)



### Install

```bash
npm install nez --save-dev
```


### For Developers.

```bash
npm install -g nez
cd ~/my_git_root/my_latest_crazy_awesome_idea
nez  # [--dev js] 
```

### Recommends

[Coffee Script](http://coffeescript.org/) - For a symantically ideal experience.


### Usage (in your spec files)

This may change:

```coffee

require('nez').realize 'Periscope', (Periscope, test, it, should) ->

    it 'keeps your head above water', (done) -> 

        periscope = new Periscope()


        #
        # 1. Create expectations
        #

        periscope.expect riseToSurface: with: 'distance', returning: true
        periscope.expect openLens: returning: true


        #
        # 2. Perform action
        #

        periscope.activate()


        #
        #   Clarification
        #   =============
        # 
        # 
        #   - riseToSurface() and openLens() may or may not already have 
        #     been implemented... 
        #   
        #     But now, having declared the expectations, the functions do 
        #     exist and will return true when called.
        # 
        # 
        #   - the intention is threefold
        # 
        # 
        #       Creation of Specification
        #       -------------------------
        #   
        #         It specifies that the call to activate() should 
        #         lead internally to a call to riseToSurface() with 
        #         the argument 'distance'
        #   
        #   
        #       Validation of Behaviour
        #       -----------------------
        #   
        #         It validates that when activate() receives true 
        #         from the call to riseToSurface() that it then goes 
        #         on to call openLens() 
        #   
        # 
        #       Clarity at Design time
        #       ----------------------
        # 
        #         A veryvery powerful thing... 
        # 
        #         (that might start happening)
        # 
        # 
 

        #
        # 3. Validate expectations
        # 
        #    THIS BIT STILL UNDER DEVELOPMENT
        #

        test done


```

ChangeLog
---------

0.0.1 currently under development

