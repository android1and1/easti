nohm = (require 'nohm').Nohm
module.exports = nohm.model 'tricks',
  idGenerator:'increment'
  properties:
    about:
      type:'string'
      unique:true
      validations: [
          name:'length'
          options:
            min:6
            max:16
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
    
