ThrusterSignalBus1 = require('../lib/nez').linked 'ThrusterSignalBus1'

ThrusterSignalBus1

    as:    'the guidance system'
    to:    'rotate the craft and then stop the rotation'
    need:  'thruster instruction sequence package'
    title: 'burn package', (specs) -> 

        specs.link 'spec/protocols/burn_package_spec'

