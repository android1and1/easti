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
    tree = await Nohm.factory 'hereistree'
    tree.property 'append','give a strong arm.'
    tree.property {
        name:'hihillp'
        latin_name:'hx2o'
        whatistime: Date.now()      
      }
    await tree.save()
  catch error
    console.log tree.errors
    console.log '/ /'.repeat 44 
    throw new Error 'Exit.'
  for k,v of tree.allProperties()
    console.log k,':',v
  client.quit()
    
client.on 'error',(err)->
  console.log 'has Error FounD.'
  console.dir err

client.on 'end',->console.log 'quit.'
