nohm = require 'nohm'
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
        old = ''
        new Date
    whatistime:
      type:'timestamp'
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

module.exports = TreeClass
