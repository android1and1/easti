http = require 'http'
app = require '../app.js'
server  =  http.Server app
server.listen 3003,->
  console.log 'server running at port 3003;press Ctrl-C to terminate.'
