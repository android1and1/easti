# neighborhood's car registing,journal,matching. as a proticle for learning nohm.
# e301,2018-12-19
nohm = require 'nohm'
NohmModel = nohm.NohmModel
class NeighborCar extends NohmModel
  @modelName = 'neighborCar'
  @getDefinitions = ->
    @definitions

  @version = '1.0'

  @idGenerator = 'increment'

  @definitions =
    # fields - licence_number,brand,color,where_seen,vehicle_model,whatistime,memo
    licence_number:
      type:'string'
      unique:true
      validations: [
          'notEmpty'
        ]
        
    brand:
      type:'string'
      index:true
      validations: [
          'notEmpty'
        ]
    color:
      type:'string'
      index:true
    where_seen:
      type:'string'
    vehicle_model:
      type:'string'
      index:true
      validations: [
          'notEmpty'
        ]
    whatistime:
      type: 'timestamp'
      index: true
      defaultValue: Date.now() 
      validations:['notEmpty']
    memo:
      defaultValue:''
      type:'string' 

    visits:
      defaultValue: 0 
      type: (newv,key,oldv)->
        newv =  1 + parseInt(oldv) 
        return newv
module.exports = NeighborCar
