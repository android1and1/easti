request = require 'superagent'
request.post 'http://127.0.0.1:3003/superagent-post'
  .field 'name','henry'
  .field 'age',44
  .attach 'image','/home/pi/Public/june4/IMG_20190604_105848.jpg'
  .end (err,res)->
    console.log res.text
  
