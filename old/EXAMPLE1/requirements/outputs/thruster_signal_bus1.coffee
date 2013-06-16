ThrusterSignalBus1 = require('../lib/nez').requirements 'ThrusterSignalBus1'

ThrusterSignalBus1

    as:    'the guidance system'
    to:    'rotate the craft and then stop the rotation'
    need:  'thruster instruction sequence package'
    title: 'burn package', (spec) -> 

        spec.link 'spec/bus_protocols/burn_package_spec'

