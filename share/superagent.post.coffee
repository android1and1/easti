# post one article 
# 2019-9-30
data = {
  urge:0
  resolved:0
  title:'a very very very patient post'
  category:'problem'
  visits:20 
  ticket:'a post,from cmd,\nfrom superagent app'
  client_time:new Date()
  admin_alias:'fengfeng2'
} 
request = require 'superagent'
request
  .post 'http://127.0.0.1:3003/no-auth-upload'
  #.type 'form' (if server side parse form via http form - "enctype=application/x-www-form-urlencoded)
  #.type 'multipart' (if server parse form data via "multipart/form-data")
  #.send {'version':'1.4.2'} # if default(no .type) situation,form parsed via multipart/form-data
  .send data
  .then (res)->
    console.log 'xxxx received server response.xxxxx'
    console.log res.text
    console.log 'xxxx received server response.xxxxx'
  .catch (err)->
    console.log err.message
###
(sample)
field:urge
value 0
field:"resolved" 
value:false
field:"title"
value: chen op o kon gg 
field:"category"
value:tool
field:"visits"
value:0
field:"ticket"
value: chao cuan fans minion how to record audio? 
field:"client_time"
value: Thu Jun 27 2019 07:58:19 GMT+0800 (CST)
field:"admin_alias"
value: "fool"
field:"ticket_id"
value: 2
(optional)
field:"media"
value:"/ticket_root/url-to-media"
field:"update-time"
value:new Date()
###
