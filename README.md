nez
===

A Declarative Expectation Framework<br />

*For Node / Mocha / Coffee*


### Due Homage

[RSpec](http://rspec.info/)



### Install

```bash
npm install nez --save-dev
```

### Recommends

[Coffee Script](http://coffeescript.org/) - For a symantically ideal experience.


### Usage

This may change:

```coffee

should    = require 'should'
Periscope = require '../src/submarine/tools/periscope'
test      = require('nez').test

describe 'Periscope', -> 

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

