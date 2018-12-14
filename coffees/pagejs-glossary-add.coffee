###
  target-file-name: ./public/pagejs/glossary/pagejs-glossary-add.js
  view: ./views/glossary/add.pug
  module: ./modules/md-glossary.js
  router: ./routes/route-glossary.js
### 
$ ->
  $('form').on 'submit',(evt)->
    return true 
