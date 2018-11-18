nohm = (require 'nohm').Nohm

dear = nohm.model 'tricks',
  idGenerator:'increment'
  properties:
    about:
      type:'string'
      unique:true
      validations: [
        {
          name:'length'
          options:
            min:4
            max:26
        }
        ,
        # minus(-) and single quote(') be blocked. 
        (value,options)->
          return not /['-]/.test value 

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
dear.prefixes = [
    'EastI'    # it is db name - prefixes[0]
    'tricks'   # it is table name  -prefixes[1] 
  ]
module.exports  = dear
