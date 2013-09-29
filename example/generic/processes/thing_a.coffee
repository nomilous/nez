# 
# SECRET=S3CR3T ../../bin/realize -p 9000 processes/thing_a.coffee
#

title: 'Do Thing A'
uuid:  '00000000-0000-0000-0001-000000000002'
realize: (thing) -> 

    before all: -> @count = 0

    thing 'step 1', (end) -> @count++; end()
    thing 'step 2', (end) -> @count++; end()
    thing 'step 3', (end) -> @count++; end()
    thing 'step 4', (end) -> @count++; end()
    thing 'step 5', (end) -> @count++; end()
