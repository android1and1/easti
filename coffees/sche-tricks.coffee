nohm = (require 'nohm').Nohm

dear = nohm.model 'tricks',
  idGenerator:'increment'
  properties:
    about:
      type:'string'
      unique:true
      validations: [
          name:'length'
          options:
            min:6
            max:26
        ]
    
    visits:
      type:'integer'
      defaultValue:0
      index:true
    content:
      type:'string'
      defaultValue:''
    moment:
      type:'timestamp'
      defaultValue: 0 
dear.prefix = 'tricks'    
module.exports  = dear
