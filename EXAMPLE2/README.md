Example2
========

Hierarchical Systems/Processes Modeling

### Behaviour Injection Plugin API

*PENDING*<br />

eg.

```coffee
#!/usr/bin/env coffee

#
# Monitoring Root Node (Thread)
#

monitor = require('nez').plugin 'trax',

    port: 10101
    cert: '/path/to/crypto/certs'


monitor 'domain.com', (proxy) -> 


    proxy 'monitor.databases.domain.com', (et) -> 

        et 'cetera'


    proxy 'monitor.webservers.domian.com', (ipso) ->

        ipso 'facto'


    proxy 'monitor.field-agents.smart-phones.domain.com', (eo) ->

        eo 'ipso'


    proxy 'monitor.mailrelays.domian.com', (jack) ->

        jack 'jill', (hill, Mountain) -> 

            hill 'mole', (make) -> 

                make.link

                    type: 'socket.io'
                    uri:  'https://dear.liza.net/spares/bucket'


    proxy DO: 'Stop messing about now...', (theres, Much, To, Be, done) ->

        theres Much To Be done()

```

