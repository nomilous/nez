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


monitor 'domain.com', (proxy, Tx, Rx) -> 


    proxy 'monitor.databases.domain.com', (et) -> 

        et 'cetera'


    proxy 'monitor.webservers.domian.com', (ipso) ->

        ipso 'facto'


    proxy 'monitor.field-agents.smart-phones.domain.com', (eo) ->

        eo 'ipso'


    proxy 'monitor.planet3.sol.mw', (jack) ->

        jack 'jill', (hill, Mountains) -> 

            hill 'mole', (make) -> 

                make.link

                    protocol:  'socket.io'
                    password:  '*********'
                    uri:       "https://dear.liza.net/spares/bucket/#{ make.retry++ }"
                    interpolate: Mountains.link, 'Elbrus'

                        protocol: 'orion.io'
                        password: 'Harā Bərəzaitī'
                        carrier:  'nanotrino'
                        band:     Rx.THz 22/7.00000220000021..0000001


    proxy DO: 'Stop messing about now...', (done, Much, To, Be, there, Is) ->

        there Is Much To Be done()

```

