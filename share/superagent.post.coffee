data = {
  urge:0
  resolved:0
  title:'ok,let us say,it really awesome!'
  category:'problem'
  visits:20 
  ticket:'i think it is magic.\nsuperagent from latitude\ngive you some data and a picture.\nEnjoy!'
  client_time:(new Date()).toISOString() # form-hidden
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
  .send {'alias':'fengfeng2'}
  .send {'password':'1234567'}
  .end (err,resp)->
    if not err
      agent.post 'http://192.168.5.2:3003/admin/create-new-ticket'
      .field 'title',data.title
      .field 'category',data.category
      .field 'visits',data.visits
      .field 'ticket',data.ticket
      .field 'client_time',(new Date()).toISOString()
      .field 'admin_alias','fengfeng2'
      .attach 'media','/home/cyrus/Pictures/bingwallpaper/bw.jpg' # i write 'attatch'(add one 't')here,cause failure all afternoon!
      .end (err,resp)->
        if err
          console.error err.message
        else
          console.log resp.text
