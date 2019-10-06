# post one article 
# 2019-9-30
###
data = {
  urge:0
  resolved:0
  title:'a very very very patient post'
  category:'problem'
  visits:20 
  ticket:'a post,from cmd,\nfrom superagent app'
  client_time:new Date() # form-hidden
  admin_alias:'fengfeng2' # form-hidden
  #(optional)
  media:'/path/to/media'
} 
###
request = require 'superagent'
request
  .post 'http://127.0.0.1:3003/admin/login'
  # 注意，如果是www-url-encoded(非AJAX），要设置如下一行所做的。因为默认传输格式是form/multipart
  .type 'form'
  #.get 'http://127.0.0.1:3003/admin/login'
  .send {'alias':'fengfeng2'}
  .send {'password':'1234567'}
  .then (responseObject)->
    ro = responseObject
    #console.dir ro
    console.log ro.text
  .catch (errObj)->
    console.dir errObj
