express = require 'express'
router = express.Router()

router.get  '/iphone-uploading',(req,res,next)->
  res.render 'uploading/iphone-uploading'
router.post  '/iphone-uploading',(req,res,next)->
  res.redirect 302,'/uploading/successfully' # 302 is default code.
router.get '/successfully',(req,res,next)->
  res.render 'uploading/successfully',{title:'iphone-uploading-success'}
module.exports = router
