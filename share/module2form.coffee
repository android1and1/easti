pug = require 'pug'
client = (require 'redis').createClient()
nohm = require 'nohm'
Nohm = nohm.Nohm

TreeClass = require './md-share-hereistree.js'

client.on 'connect',->
  Nohm.setPrefix 'laofu'
  Nohm.setClient @
  treeModel = Nohm.register TreeClass
  # first of first,decide keep old data or not,if want delete datas,use tmp/deleteA.coffee.
  try
    tree = await Nohm.factory 'hereistree',1
  catch error
    throw new Error 'not found id==1'
  # load html
  console.log tree.pugTags 
  client.quit()

  # use pure node-redis api
  #client.keys '*hereistree*',(err,arr)->
  #  for a in arr
  #    console.log a
  #  client.quit()
    
client.on 'error',(err)->
  console.log 'has Error FounD.'
  console.dir err

client.on 'end',->console.log 'quit.'
