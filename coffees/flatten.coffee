# written by al.di 2018
# help function
types = [
  'isString'
  'isArray'
  'isObject'
  'isNumber'
  'isRegExp'
  'isDate'
  'isBoolean'
  ]

helpFuncs = {}

for type in types
  ((x)->
      # func name is 'x'
      helpFuncs[x] = (check)->
        ('[object ' + x.substr(2) + ']') is (Object.prototype.toString.call check)
  )(type) 


objectSortByIndex = (obj)->
  # in:an obj within score-like index
  # out(return): a sorted array.
  indexes = Object.keys(obj)
  orded = indexes.sort (a,b)->a-b #from min to max
  result = {}
  counter = 0
  for i in orded
    result[counter++] = obj[i]
  return result 

scanresults = 
  item1:'just string'
  item2:
    name: 'bob marley'
    year: 1985
    title: 'no woman no cry'
    peoples:[
      'wang lin'
      'hua shao'
      'zeng ji yi'
      'lu ping'
      ]
  item3: 'just another string'
  item4: [
    'small'
    'middle'
    'large'
    'extro large'
    ]
  item5: 'just string,again'

flatten = (original,store,major=0,minor=0)->
  # store is an outter-level array variable.
  # major and minor initial all is 0,they maps the deep levels like filesystem
  flag = switch
    when helpFuncs.isString original then 'string'
    when helpFuncs.isArray original then 'array'
    when helpFuncs.isObject original then 'object'
    when helpFuncs.isNumber original then 'number'
    when helpFuncs.isDate original then 'date'
  
  if flag is 'string' or flag is 'number' or flag is 'date'
    index = major + '.' + minor
    store[index] =  original
  else if flag is 'array' 
    for v,i in original
      flatten v,store,major+1,minor++
  else if flag is 'object'
    for i,v of original
      flatten v,store,major+1,minor++
  else
    flatten 'unknown',store,major,minor
  null
exports.flatten = flatten
exports.sample = scanresults
exports.objectSortByIndex = objectSortByIndex
