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
module.exports = Daka
