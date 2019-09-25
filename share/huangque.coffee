fs = require 'fs'
request = require 'superagent'
request.get "https://av.voanews.com/clips/VCH/2019/06/19/3a6a2559-4957-46e9-aeef-68e5e0c97829.mp3"
#request.get 'https://av.voanews.com/clips/VCH/2019/06/18/e2564e14-852c-4782-b181-9cc76c551a7d-852c-4782-b181-9cc76c551a7d.mp3?download=1'
  .end (req,res)->
    ws = fs.createWriteStream './voices/a.mp3'
    ws.on 'finish',->
      process.exit 0
    ws.write res.body,'binary' 


