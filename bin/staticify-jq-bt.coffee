fs = require 'fs'
project_root = undefined
if process.argv[0] isnt 'coffee' 
  console.log 'Usage: (cd ~/easti) coffee bin/staticify-jq-bt.coffee' 
  process.exit 1
else if  process.argv[1] isnt (fs.realpathSync 'bin/staticify-jq-bt.coffee')
  console.log 'Usage: (cd ~/easti) coffee bin/staticify-jq-bt.coffee' 
  process.exit 1
 
if false is fs.existsSync '../easti' # cmdline runing within <project-root> -- '.',so '..' is '~'
  console.log 'need within project root path,and project is easti only.'
  process.exit 2
else if false is fs.existsSync './public' 
  console.log 'need a "public/" directory' 
  process.exit 2

if false is fs.existsSync './node_modules'
  console.log 'no found ./node_modules directory,perhaps need npm init.'
  process.exit 3
else if false is fs.existsSync './node_modules/jquery'
  console.log 'no found package:jQuery,need prepare it.'
  process.exit 3
else if false is fs.existsSync './node_modules/bootstrap'
  console.log 'no found package:Bootstrap,need prepare it.'
  process.exit 3

# copy jquery.min.js
rs = fs.createReadStream './node_modules/jquery/dist/jquery.min.js','utf-8'
ws = fs.createWriteStream './public/jquery.min.js',{flag:'w'}
ws.on 'close',->console.log 'jquery.min.js created at public/'
rs.pipe ws

# copy bootstrap package
spawn = (require 'child_process').spawn
cp = spawn 'cp',['-a','-r','./node_modules/bootstrap/dist','./public/bootstrap']
cp.on 'close',->
  console.log 'copy bootstrap@3 into public/'
