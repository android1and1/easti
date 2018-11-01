nohm = require 'nohm'
.Nohm
redis = (require 'redis').createClient() # default 6379 port redis-cli
# include our Model
sche = require '../modules/sche-tricks'
DBPREFIX = sche.prefixes[0]
HASHPREFIX = sche.prefixes[1]
nohm.on 'error',(err)->
  console.error err.message

nohm.on 'connection',->
  nohm.setClient redis
  nohm.setPrefix DBPREFIX
  
  ins = await nohm.factory HASHPREFIX
  
