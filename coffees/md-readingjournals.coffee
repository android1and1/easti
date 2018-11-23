# outter codes access this module,step1:require this;step2 "nohm.register this"!
pug = require 'pug'
NohmModel = (require 'nohm').NohmModel
class ReadingJournals extends NohmModel
  @version = '1.0' 
  # mod2form as 'Admin Class'
  @mod2form = ->
    # variables:['url','opts'] 
    form = '''
      p
      form(action= url,method='POST' id="bootform")
        - for(attr in opts){
            .form-group
              label(for= 'id' + attr)= attr
              - if(opts[attr].widget==='textarea')
                textarea(class="form-control",rows="5",name=attr,id= 'id' + attr) 
              - else{
                - if(opts[attr].type === 'integer') 
                  - type='number'
                - else if(opts[attr].type === 'timestamp')
                    -  type='datetime'
                - else
                  - type='text'
                input(class="form-control",id= 'id' + attr,name= attr,type= type )
              - }
        - }
          .form-group  
            button(class="idoido btn btn-lg btn-default") Submit!  
      p
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
      # type 1 is 'wenxue' 2 is 'zhentan',3 is 'kexue',4 is 'lishi'....
      defaultValue:33
      index:true
       
    timestamp:
      type:'timestamp'
      validations:[
        'notEmpty'
      ]
      index:true
    journal:{
      widget:'textarea'
      type:'string'
      validations:[
        'notEmpty'
      ]
    }
    
    reading_history:{
      type:'string'
      defaultValue:'empty'
    }
  }

module.exports = ReadingJournals
