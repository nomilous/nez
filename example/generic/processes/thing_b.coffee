# 
# SECRET=S3CR3T ../../node_modules/.bin/realize -p 9000 processes/thing_b.coffee
#

title: 'Do Thing B'
uuid:  '00000000-0000-0000-0001-000000000003'
realize: (thing) -> 

    thing 'step 1', (end) -> end()
    thing 'step 2', (end) -> end()
    thing 'step 3', (end) -> end()
    thing 'step 4', (end) -> end()
    console.log TODO: 'error on duplicate phase title'
    thing 'step 4', (end) -> end()
