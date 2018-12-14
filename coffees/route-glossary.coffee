express = require 'express'
router = new express.Router
{definitions,getFields} = require '../modules/md-glossary.js'
sqlite = require 'sqlite3'
sqlite.verbose()
db = new sqlite.Database 'sqlitedb/sqlite.sql',->
  db.run definitions
# list
router.get '/',(req,res,next)->
  # list top10
  db.serialize ->
    db.all 'select * from glossary limit 10',(err,arr)->
      if err is null
        res.render 'glossary/index.pug',{title:'top10 list',top10:arr}
      else
        res.render 'glossary/index.pug',{title:'top10 list',error:'database error.'} 
# add
router.get '/response',(req,res,next)->
  res.render 'glossary/response.pug'

router.get '/add',(req,res,next)->
  # Notice That,this is dynamiclly created form.
  fields = getFields()
  res.render 'glossary/add.pug',{fields:fields}
  
router.get '/want-update/:id',(req,res,next)->
  db.get 'select * from glossary where id = ?',req.params.id,(err,item)->
    if err
      res.render 'glossary/item.pug',{title:'detail page',item:undefined}
    else
      res.render 'glossary/item.pug',{title:'detail page',item:item,fields:getFields()}
   
router.post '/updated',(req,res,next)->
  
router.post '/add',(req,res,next)->
  body = req.body
  db.serialize ->
    stmt = db.prepare 'insert into glossary (term,about,article,visits,last_visited) values (?,?,?,?,?)'
    stmt.bind body.term,body.about,body.article,body.visits,body.last_visited
    stmt.run()
    stmt.finalize ->
      res.redirect '/glossary/response'
  

glossaryFactory = (app)->
  return (whichpath)->
    app.use whichpath,router

module.exports = glossaryFactory

###
  this route map one table: "glossary",its definition at 'modules/md-glossary.js'
  written by a.d
  2018-12-12
###
