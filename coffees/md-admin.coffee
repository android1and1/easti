pug = require 'pug'
class Admin
  @version = '1.0' 
  @mod2view = (modelClass)->
    abc= '''
    form.form-horizontal
      .form-group
        label(for= 'id' + field_label)= field_label 
        input(type=field_type id= 'id' + field_label class="form-control" placeholder="you know..")
      .form-group
        button(class="sumbmit") Submit!
    ''' 
    definitions = modelClass.getDefinitions() 
    firstkey = Object.keys(definitions)[0]
    console.log pug.render abc,{field_label:firstkey,field_type:definitions.title.type}
    pug.render abc,{field_label:firstkey,field_type:definitions.title.type}
    
# a help func - _parse
_parse = (definition)->
  # quantete the format of 'definition' object
  # we need output like this format:
  #   [{type:'string',TODO
  null
module.exports = Admin
