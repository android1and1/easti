# post one article 
# 2019-9-30
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
  #media:'/path/to/media'
} 
request = require 'superagent'
agent = request.agent()
agent
  .post 'http://192.168.5.2:3003/admin/login'
  # 注意，如果是www-url-encoded(非AJAX），要设置如下一行所做的。因为默认传输格式是form/multipart
  .type 'form'
  #.get 'http://127.0.0.1:3003/admin/login'
  .send {'alias':'fengfeng2'}
  .send {'password':'1234567'}
  .end (err,resp)->
    if not err
      agent.post 'http://192.168.5.2:3003/admin/create-new-ticket'
      .send data
      .end (err,resp)->
        if err
          console.error err.message
        else
          console.log resp.text
     
