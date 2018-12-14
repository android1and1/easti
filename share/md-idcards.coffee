NohmModel = (require 'nohm').NohmModel
class Idcards extends NohmModel
  @modelName = 'idcards'
  @idGenerator='increment'
  @version='1.2'
  @getDefinitions= ->
    return @definitions
  @definitions = 
    hashnumber:
      type:'integer'
      validations:['notEmpty'] 
    staff:
      type:'string'
      validations:['notEmpty'] 
    inittime:
      type:'integer'
      validations:['notEmpty'] 
    updatetime:
      type:'integer'
      validations:['notEmpty'] 
exports.Idcards = Idcards
