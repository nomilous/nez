# 
# SECRET=S3CR3T ../../bin/realize -c -p 9000 processes/thing_c.coffee
#

title: 'Do Thing C'
uuid:  '00000000-0000-0000-0001-000000000004'
realize: (thing) -> 

    thing 'step 1', (end) -> 
    thing 'step 2', (end) -> 
    thing 'step 3', (end) -> 
    thing 'step 4', (end) -> 
    thing 'step 5', (end) -> 
    
