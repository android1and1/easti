nohm = (require 'nohm').Nohm
module.exports = nohm.model 'User'
  ,
  idGenerator:'increment'
  properties:
    name:
      type:'string'
      validations:['notEmpty']
      unique:true
    email:
      type:'string'
      validations:['email','notEmpty']
      unique:true
    password:
      type:'string'
    visits:
      type:'integer'
      index:true
