nez
===

Declarative Expectation Framework<br />

For Node / Mocha / Coffee


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
        # create expectation:
        # 
        # - that the riseToSurface() function will be called
        # - and that the expected argument(s) will be 'distance'
        # - ,
        # - and pretend it worked... (by specifying what to return)
        #

        periscope.expectCall riseToSurface: with: 'distance', returning: true


        #
        # perform testable action
        #

        periscope.activate()


        #
        # validate - were the expectations met?
        # 
        # THIS BIT STILL UNDER DEVELOPMENT
        #

        test done


```


### Due Hommage

[RSpec](http://rspec.info/) - For being awesome enough to `Actually! Get! Me! Testing!`


ChangeLog
---------

0.0.1 currently under development
