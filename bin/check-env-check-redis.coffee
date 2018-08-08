{spawn} = require 'child_process' 
which = spawn 'which',['redis-server']
output = '' 
which.stdout.on 'data',(data)->
  output += data
which.on 'close',(code)->
  if code isnt 0
    console.log 'redis-server no found.' 
  else
    console.log 'redis-server satisfied.at %s.',output 
