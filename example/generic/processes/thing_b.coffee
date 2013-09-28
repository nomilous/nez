# 
# SECRET=S3CR3T ../../bin/realize -c -p 9000 processes/thing_b.coffee
#

title: 'Do Thing B'
uuid:  '00000000-0000-0000-0001-000000000003'
realize: (thing) -> 

    thing 'step 1', (end) -> 
    thing 'step 2', (end) -> 
    thing 'step 3', (end) -> 
    thing 'step 4', (end) -> 
    thing 'step 5', (end) -> 
    