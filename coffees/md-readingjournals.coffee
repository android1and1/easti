# outter codes access this module,step1:require this;step2 "nohm.register this"!
pug = require 'pug'
NohmModel = (require 'nohm').NohmModel
class ReadingJournals extends NohmModel
  @version = '1.0' 
  # below method - mod2snippet is as 'Admin Class'
  @mod2snippet = ()=>
    form = '''
      form.form-horizontal
      - for(attr in opts){
          .form-group
            label(for= 'id' + attr)= attr
            - var type=opts[attr].type
            - 
              if(type==='string')
                type='text'
              else if(type==='integer')
                type='number'
              else if(type==='timestamp')
                type='datetime'
              else
                type='unkown'
            input(class="form-control",id= 'id' + attr,name= label,type= type )
      - }
        .form-group  
          button(class="btn btn-lg btn-default") Submit!  
    '''
    form 

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
        {'name':'length',options:{'min':4,'max':228}}
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
    tag:
      type:'integer'
      defaultValue:33
      index:true
       
    timestamp:
      type:'timestamp'
      defaultValue:0

    journal:{
      type:'string'
      validations:[
        'notEmpty'
      ]
    }
    
    reading_history:{
      type:'string'
      defaultValue:''
    }
  }

module.exports = ReadingJournals
