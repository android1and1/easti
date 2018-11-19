# filename "md-admin-readingjournals"
# rewrite from md-admin
pug = require 'pug'
nohm = (require 'nohm').Nohm
ReadingJournals = require './md-readingjournals.js'
class Admin
  @version = '1.0'
  @mod2snippet = (modelClass)->
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
    return pug.render abc,{field_label:firstkey,field_type:definitions.title.type}
    
module.exports = Admin
