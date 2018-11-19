RJ = require '../modules/md-readingjournals.js'
nohm = (require 'nohm').Nohm
client = (require 'redis').createClient()

client.on 'connect',->
  nohm.setPrefix 'seesee'
  nohm.setClient @
  # if nessary,purge db 'seesee' 
  #await nohm.purgeDb()
  # really.
  rj = nohm.register RJ 
  for i in [1..4]
    ins = new rj
    ins.property
      title: 'history topic#' + i
      author: 'James Johnny'
      timestamp: '2004-9-4 21:20:22'
      reading_history:'2014-10-1,am'
      journal:'it is funny,fnufunny #' + i
    try
      await ins.save()
      console.log 'saved.'
    catch error
      console.dir ins.errors
  console.log 'done.'
  definitions = RJ.getDefinitions()
  setTimeout ->
      console.dir definitions
      client.quit()
    ,
    1500
