# table "glossary"
definitions = '''
  create table if not exists glossary (
    id INTEGER PRIMARY KEY NOT NULL,
    term varchar(100) unique,
    about varchar(100),
    article text not null,
    visits integer not null default 1,
    last_visited datetime 
    )
''' 

getFields = ->
  #below field will display at html-form
  return [
    {field_name:'term',widget:'input',input_type:'text'}
    ,
    {field_name:'about',widget:'input',input_type:'text'}
    ,
    {field_name:'article',widget:'textarea'}
    ,
    {field_name:'visits',widget:'input',input_type:'number'}
    ,
    {field_name:'last_visited',widget_type:'input',input_type:'datetime'}
  ]
exports.definitions = definitions
exports.getFields = getFields
