### Due Homage

[RSpec](http://rspec.info/)

### Current Version

0.0.6 (pre-release)

### Pending Features

* **fix** fing
* function and property expections
* before and after hooks
* expanded linking capabilities
* expanded plugin capabilities
* tree integration

### Install

```bash
npm install nez --save-dev
```

### Recommends

[Coffee Script](http://coffeescript.org/) - For a symantically ideal experience.

### General Usage

This may (Still) change:


```coffee
require('nez').realize 'ClassName', (Subject, validate, stacker, should) ->

    stacker 'push labeled node into tree', (that) ->

        that 'is a heirarchy of tests', (done) ->

            should.should.should.exist 'tests (here)'
            validate done


```

