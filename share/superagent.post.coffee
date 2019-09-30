request = require 'superagent'
request.post 'http://127.0.0.1:3003/admin/create-new-ticket'
  .type 'form'
  .send {alias:'fool',password:'1234567'}
  .end (err)->
    if err is null
      request.get 'http://127.0.0.1:3003/admin/newest-ticket'
      .end (err,res)->
         console.log res.text
