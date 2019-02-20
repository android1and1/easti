{NohmModel} = require 'nohm'
class Daka extends NohmModel
  @modelName = 'daily'
  @idGenerator = 'increment'
  @definitions = 
    name:
      type:'string'
      index:true
      validations:['notEmpty']
    code:
      type:'integer'
      index:true
      validations:['notEmpty']
    
module.exports = Daka
