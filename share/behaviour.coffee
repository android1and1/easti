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
      load_pure:true

    story:
      defaultValue:''
      load_pure:true
      type:'string'

    append:
      type:(newV,key,oldV)->
        old = @property 'story' 
        @property 'story',old + '\n' + newV
        new Date
    whatistime:
      type:'json'
      dafaultValue : Date.now()
      validations:['notEmpty']


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

  # use pure node-redis api
  #client.keys '*hereistree*',(err,arr)->
  #  for a in arr
  #    console.log a
  #  client.quit()
    
client.on 'error',(err)->
  console.log 'has Error FounD.'
  console.dir err

client.on 'end',->console.log 'quit.'
