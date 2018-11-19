pug = require 'pug'
NohmModel = (require 'nohm').NohmModel
class ReadingJournals extends NohmModel
  @version = '1.0' 
  @mod2snippet = ()=>
    abc= '''
      -
        if(field_type === 'string')
          field_type='text';

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
