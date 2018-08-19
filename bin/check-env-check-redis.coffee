{spawn} = require 'child_process' 
# make a common method,to check each of expected softwares.sw==software.
spawncheck = (sw)->
  child = spawn 'which',sw
  child.on 'close',(code)->
    if code isnt 0
      console.log '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      console.log '@@\t%s NO found.',sw 
      console.log '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'

[['mocha'],['coffee'],['redis-server'],['redis-cli']].forEach((ele)->spawncheck(ele))
