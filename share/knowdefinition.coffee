pug = require 'pug'
client = (require 'redis').createClient()
nohm = require 'nohm'
Nohm = nohm.Nohm

# definitions
class TreeClass extends nohm.NohmModel
  @modelName = 'hereistree'
  @idGenerator = 'increment'
  @definitions = 
    name:
      type:'string'
      unique:true
      
    latin_name: 
      type:'string'
      unique:true
      load_pure:true

    story:
      defaultValue:''
      load_pure:true
      type:'string'

    append:
      type:(newV,key,oldV)->
        old = @property 'story' 
        @property 'story',old + '\n' + newV
    whatistime:
      type:'json'
      dafaultValue : Date.now()


  @createHTML = ->
    return pug.render @pugTags,{treeid:@id} 

  @pugTags = '''
    form(class="form-horizontal" action="" method="POST" enctype="multipart/form-data")
      .form-group
        label(for= treeid,class="col-sm-2 control-label") The Id Of This Tree
        .col-sm-10
          input(type="text" class="form-control" id= treeid name="treeid")
      .form-group
        .col-sm-offset-2.col-sm-10
          button(class="btn btn-lg btn-success" type="submit") Submit!
        
    '''

client.on 'connect',->
  Nohm.setPrefix 'gaikai'
  Nohm.setClient @
  treeModel = Nohm.register TreeClass
  tree = await Nohm.factory 'hereistree',2
  tree.property 'name','llulaby2'
  tree.property 'latin_name':'oiuoolaoiwilbyo'
  tree.property 'append','fake.' 
  try 
    await tree.save()
  catch error
    console.log 'DEBUG INFO:'
    console.dir error 
  ids = await tree.find 'name':'llulaby2'
  obj = await tree.load ids[0]
  for k,v of obj
    console.log k,':',v
  
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
