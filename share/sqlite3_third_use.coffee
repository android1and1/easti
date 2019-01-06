sqlite = require 'sqlite3'
sqlite.verbose()
db = new sqlite.Database('./tmp/thousand.sql')
#db = new sqlite.Database(':memory:')
db.serialize ->
  db.run 'drop table if exists test'
  db.run '''
    create table if not exists test (
      id integer primary key not null,

      name varchar(29) not null,
      age integer not null,
      address varchar(22),
      story text
    )
    '''
      
  console.log 'started at' , new Date
  db.serialize ->
    for i in [1..1000]
      stmt = db.prepare 'insert into test (name,age,address,story) values (?,?,?,?)'
      stmt.bind 'name#' + i,i,'address#' + i,'stroy #' +i
      stmt.run()
  db.get 'select count(*) as counts from test',(err,num)->
    console.log 'inserted',num,'items.'
     
  db.close ->
    console.log 'ended at' , new Date
