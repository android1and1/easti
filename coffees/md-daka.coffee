{NohmModel} = require 'nohm'
class Daka extends NohmModel
  @modelName = 'daily'
  @idGenerator = 'increment'
  @definitions = 
    alias:
      type:'string'
      validations:['notEmpty']
      index:true
    utc_ms:
      type:'integer'
      validations:['notEmpty']
      index:true
    browser:
      type:'string'
    whatistime:
      type:'string'
      validations:['notEmpty']
    dakaer:
      type:'string'
      validations:['notEmpty']
      defaultValue:'self'
    category:
      type:'string'
      validations:[
          'notEmpty' 
          (value,options)->
            Promise.resolve value in ['entry','Entry','exit','Exit']
        ]
        
module.exports = Daka
