rj = require '../modules/md-reading-journals'
nohm = (require 'nohm').Nohm
client = (require 'redis').createClient()

client.on 'connect',->
  nohm.setPrefix 'seesee'
  nohm.setClient @
  await nohm.purgeDb()
  # really.
  for i in [1..4]
    ins = new rj
    ins.property
      name: 'itisname#' + i
      age: i*i
      tt: '2018-11-20 8:00:00'
    try
      await ins.save()
      console.log 'saved.'
    catch error
      console.dir ins.errors
  console.log 'done.'
  definitions = rj.getDefinitions()
  setTimeout ->
      console.log definitions.name.defaultValue
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
