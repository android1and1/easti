express = require 'express'
router = new express.Router
{definitions,getFields} = require '../modules/md-glossary.js'
sqlite = require 'sqlite3'
sqlite.verbose()
db = new sqlite.Database 'sqlitedb/sqlite.sql',->
  db.run definitions
db.on 'error',(err)->
  console.log '::debug info::',err

# list
router.get '/',(req,res,next)->
  # list top10
  db.serialize ->
    db.all 'select * from glossary limit 10',(err,arr)->
      if (arr.length is 0) or err 
        res.render 'glossary/not-ready.pug',{title:'top10 list',error:'database error or empty list.'} 
      else
        res.render 'glossary/index.pug',{title:'top10 list',top10:arr}

#router.post '/search',(req,res,next)->
router.get '/search',(req,res,next)->
  # ajax-client post data 
  # then parse it as field and value,look for db,retrieve item.
  res.send 'query string: ' + JSON.stringify req.query 
    
 
router.get '/response',(req,res,next)->
  res.render 'glossary/response.pug'

router.get '/add',(req,res,next)->
  # Notice That,this is dynamiclly created form.
  fields = getFields()
  res.render 'glossary/add.pug',{fields:fields}

router.get '/delete/:id',(req,res,next)->
  db.exec 'delete from glossary where id=' + req.params.id

router.get '/update/:id',(req,res,next)->
  db.get 'select * from glossary where id = ?',req.params.id,(err,item)->
    if err
      res.send 'database error while doing select query.'
    else if item is undefined
      res.render 'glossary/no-this-item.pug',{title:'detail page'}
    else
      res.render 'glossary/item.pug',{title:'detail page',item:item,fields:getFields()}
   
   
router.post '/updated',(req,res,next)->
  
router.post '/add',(req,res,next)->
  body = req.body
  db.serialize ->
    stmt = db.prepare 'insert into glossary (term,about,article,visits,last_visited) values (?,?,?,?,?)'
    stmt.bind body.term,body.about,body.article,body.visits,body.last_visited
    stmt.run (err)->
      if err
        console.log ':debug:router:glossary:',err.message
        return res.send 'has db error whild storing.'
      else
        stmt.finalize ->
          res.redirect '/glossary/response'
  
router.post '/update/:id',(req,res,next)->
  body = req.body
  db.serialize ->
    stmt = db.prepare 'update glossary set term=?,about=?,article=?,visits=?,last_visited=? where id=?'
    stmt.bind body.term,body.about,body.article,body.visits,body.last_visited,req.params.id
    stmt.run (err)->
      if err
        console.log ':debug:router:glossary:',err.message
        return res.send 'has db error while updating.'
      else
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
