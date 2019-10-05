# post one article 
# 2019-9-30
request = require 'superagent'
request
  .post 'http://127.0.0.1:3003/no-auth-upload'
  #.type 'form' (if server side parse form via http form - "enctype=application/x-www-form-urlencoded)
  #.type 'multipart' (if server parse form data via "multipart/form-data")
  .send {'version':'1.4.2'} # if default(no .type) situation,form parsed via multipart/form-data
  .then (res)->
    console.log res.text
  .catch (err)->
    console.log err.message
