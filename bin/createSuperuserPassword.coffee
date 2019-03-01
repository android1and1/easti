crypto = require 'crypto'
# the real argument(plain text) is process.argv[2]
# Usage is "coffee <this> plain-text"
if process.argv.length isnt 3
  console.log 'Usage: coffee <this-script> <plain-text>'
  process.exit 1
else
  r = crypto.createHash 'sha256'
    .update process.argv[2] 
    .digest 'hex'
  console.log r
