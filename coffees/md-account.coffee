# 2019-2
{NohmModel} = require 'nohm'
class Account extends NohmModel
  @modelName = 'account'
  @idGenerator = 'increment'
  @definitions = 
    name:
      type:'string'
      index:true
      validations:[
          'notEmpty'
          {name:'length',options:{min:4,max:15}}
          # granttee that name not contains '0' or 'o',they are not clear
          # display on screen,always.
          (value,options)->
            return Promise.resolve not /[0o]/.test value
        ]
    code:
      type:'integer'
      index:true
      validations:['notEmpty']
    password:
      type:'string'
      validations:['notEmpty']
    timestamp:
      type:'string'
      index:true
    alive:
      type:'boolean'
      validations:['notEmpty']
      defaultValue:true

module.exports = Account
