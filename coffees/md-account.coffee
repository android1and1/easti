{NohmModel} = require 'nohm'
class Account extends NohmModel
  @modelName = 'account'
  @idGenerator = 'increment'
  @definitions = 
    alias:
      type:'string'
      unique:true
      validations:[
          'notEmpty'
          {name:'length',options:{min:4,max:15}}
          # Just a sample.below:
          # granttee that name not contains '0' or 'o',they are not clear
          # display on screen,always.
          #(value,options)->
          #  return Promise.resolve not /[0o]/.test value
        ]
    role:
      type:'string'
      index:true
      validations:[
          'notEmpty'
          (val)->
            return Promise.resolve val in ['admin','superuser','user','unknown']
        ]
    # admin can disable users,but superuser should del admin,
    # not disable,and no way to do this.
    isActive:
      type:'boolean'
      defaultValue:true
    password:
      type:'string'
      validations:[
          'notEmpty'
        ]
    initial_timestamp:
      type:'integer' # utc million secs
      validations:['notEmpty']
      index:true
module.exports = Account
