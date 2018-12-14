nohm = require 'nohm'
#{Nohm,NohmModel} = nohm
{Nohm} = nohm

###
class Idcards extends NohmModel
  @modelName = 'idcards'
  @idGenerator='increment'
  @version='1.2'
  @getDefinitions= ->
    return @definitions
  @definitions = 
    hashnumber:
      type:'integer'
      validations:['notEmpty'] 
    staff:
      type:'string'
      validations:['notEmpty'] 
    inittime:
      type:'integer'
      validations:['notEmpty'] 
    updatetime:
      type:'integer'
      validations:['notEmpty'] 
###

# initial redis/nohm
client = (require 'redis').createClient()
IC = (require '../share/md-idcards.coffee').Idcards

client.on 'connect',->
  schema = Nohm.register IC
  #schema = Nohm.register Idcards
  Nohm.setPrefix 'ver3'
  Nohm.setClient @
  # let us start with a bare redis db.
  await Nohm.purgeDb @
 
  ###
    need 1000 times insertions.
    'insert' is a generator function.
  ###
  console.log 'started at',new Date
  for i in [1..1000]
    obj = await Nohm.factory schema.modelName
    obj.property 
      hashnumber:i
      staff:'i want some #' + i 
      inittime: '2008-1-18'
      updatetime:'2010-2-2' 
    try
      await obj.save()
    catch error
      console.log 'save failure,reason below:\n\t'
      console.log obj.errors
    if i is 1000
      client.quit ->
        console.log 'ended at',new Date
  
client.on 'error',(err)->
  console.error ':ver3:error:\n\t',err
