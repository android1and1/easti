assert = require 'assert'
nohm = require 'nohm'
Nohm = nohm.Nohm
NohmModel = nohm.NohmModel
# keep global db-like variables.
CommentModel = undefined
ArticleModel = undefined
cdb = undefined 
adb = undefined

class Article extends NohmModel
  @modelName = 'article'
  @idGenerator = 'increment'
  @definitions = 
    title:
      type:'string'
      unique:true
      validations:['notEmpty'] 
    intro:
      type:'string'
      validations:['notEmpty'] 
    content:
      type:'string'
    visits:
      type:'integer'
      defaultValue:0
    
class Comment extends NohmModel
  @modelName = 'comment'
  @idGenerator = 'increment'
  @definitions = 
    reader:
      type:'string'
      index:true
      validations:[
        'notEmpty'
      ]
    title:
      type:'string'
      unique:true
      validations:['notEmpty'] 
    stars:
      type:'integer'
      validations:[
        'notEmpty'
        (newv)->
          result = false
          if typeof parseInt(newv) is 'number' and parseInt(newv)<= 5
            result = true
          return Promise.resolve result 
      ] 
    content:
      type:'string'

describe 'Link Behaviour Of Nohm API:',->
  before ->
    client = (require 'redis').createClient()   
    client.on 'error',(err)->
      console.error err.message
      throw TypeError 'No Redis Server Connection'
    client.on 'connect',->
      Nohm.setClient @
      Nohm.setPrefix 'laofu'
      # register class
      CommentModel = Nohm.register Comment
      ArticleModel = Nohm.register Article
      
      #cdb == Comment DB,adb == Article DB
      cdb = await Nohm.factory 'comment'
      adb = await Nohm.factory 'article' 
      # before new test,clear the db.
      await Nohm.purgeDb @

  it 'create 1 comment and 1 article,should successfully::',->
    adb.property 
      title:'a delicate truth'
      intro:'len zhan'
      content:'at word II ,in britian da shi guan.'
    res = await adb.validate undefined,false
    if res
      await adb.save()
    else
      console.log adb.errors
    
    cdb.property
      title:'comment about a delicate truth'
      reader:'su ning'
      stars: 2 
      content:'it is wonderfulexperien while reading this story.'
    res = await cdb.validate undefined,false
    if res
      await cdb.save()
    else
      console.log cdb.errors
       
    # till here,means 1 article and 1 comment is created.
    assert.ok res 
  it 'comment id 1 should has correctly inf::',->
    properties = await cdb.load 1
    assert properties.title is 'comment about a delicate truth'

  it 'article link comment should success::',->
    adb2 = new  ArticleModel
    cdb2 = new CommentModel
    adb2.property
      title:'her name is New York'
      intro:'adult lullaby'
      content:'singer is Paloma Faith(British).'
    cdb1 = await Nohm.factory 'comment',1 # this instance created at step1(test1).
    cdb2.property
      title:'comment of new york'
      stars:4
      reader: 'tony'
      content:' Great Stroy,i like it.'
    adb2.link cdb1
    adb2.link cdb2
    await adb2.save()
    # now adb2 has 1 link which is instance of CommentModel
    num = await adb2.numLinks 'CommentModel'
    assert.equal num,0 



