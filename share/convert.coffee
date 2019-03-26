# tell us how to convert a flap obj,to a serilized array
# be used at route '/admin/daka-complement',server side resort the uploading data,then parse it for redis storeage.
fields = 
  alias0:'a person'
  option0:'a option'
  data0:'a data'
  alias1:'b person'
  option1:'b option'
  data1:'b data'
  alias2:'c person'
  option2:'c option'
  data2:'c data'
  alias3:'d person'
  option3:'d option'
  data3:'d data'
  time3:'d time'
  alias33:'x person'
  option33:'x person'
  'alias-34':'y person'
  'option-34':'y option'
  'data-first-half-34':'y data'
  alias44:'the last man'
  option44:'the last option'
  data44:'the last data'


# change fields as [{alias:'a person',option:'a option',data:'a data'},
#  {alias:'b person',option:'b option',data:'b data'}]

results = []
for i,v of fields
  # get the last char
  # consides if number is 2 bits or more.
  matched = i.match /(\D*)(\d*)$/
  prefix = matched[1]
  postfix = matched[2]
  int = parseInt postfix
  if (postfix in Object.keys(results)) is false
    results[int] = {}
  results[int][prefix] = v
console.log 'x x '.repeat 11
console.dir results
