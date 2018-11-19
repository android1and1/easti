# outter codes access this module,step1:require this;step2 "nohm.register this"!
pug = require 'pug'
NohmModel = (require 'nohm').NohmModel
class ReadingJournals extends NohmModel
  @version = '1.0' 
  # below method - mod2snippet is as 'Admin Class'
  @mod2snippet = ()=>
    abc= '''
      -
        if(field_type === 'string')
          field_type='text';
        else if(field_type === 'integer')
          field_type='number'
        else if(field_type === 'timestamp')
          field_type='time'
        else
          field_type='unknown-type'

      .form-group
        label(for= 'id' + field_label)= field_label 
        input(type=field_type id= 'id' + field_label class="form-control" placeholder="you know..")
    ''' 
    firstkey = (Object.keys @definitions)[0]
    pug.render abc,{field_label:firstkey,field_type:@definitions.title.type}

  @getDefinitions = ()=>
    @definitions

  @modelName = 'readingjournals'

  @idGenerator='increment'

  @definitions = {
    title:
      type:'string'
      unique:true
      validations:[
        'notEmpty'
      ]
    visits:
      type:'integer'
      index:true
      defaultValue:0

    author:
      type:'string'
      validations:[
        'notEmpty'
      ]
       
    timestamp:
      type:'timestamp'
      defaultValue:0

    revision_info:
      type:'string'
      
    journal:{
      type:'string'
      validations:[
        'notEmpty'
      ]
    }
  }

module.exports = ReadingJournals
