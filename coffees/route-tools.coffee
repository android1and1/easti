express = require 'express'
router = express.Router()

router.get '/tool-1',(req,res,next)->
  res.send 'hi,i am tool No.1'

module.exports = router
