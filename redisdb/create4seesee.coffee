RJ = require '../modules/md-readingjournals.js'
nohm = (require 'nohm').Nohm
client = (require 'redis').createClient()

client.on 'connect',->
  nohm.setPrefix 'seesee'
  nohm.setClient @
  # because practices all after db be purged,so unique limit is satisfy
  await nohm.purgeDb()
  # really.
  rj = nohm.register RJ 
  for i in [1..4]
    ins = new rj
    ins.property
      title: 'book#' + i
      author: 'Mark Twins' 
      timestamp: '2018-11-20 8:00:00'
      journal:'it is funny#' + i
      revision_info:'no public'
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
  ###
  xrj = new rj
  xrj.property
    name:'huang huang'
    age:40
    tt:Date.parse new Date()
  try
    await xrj.save silence:true
  catch error
    console.log 'error occurs during saving .'
    console.error .errors
  setTimeout ->client.quit()
    ,
    1500
  ###
_help = (defines)->
  null
