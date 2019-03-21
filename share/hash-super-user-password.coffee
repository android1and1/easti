crypto = require 'crypto'
sha256 = crypto.createHash 'sha256'
digest = sha256.update 'i am super user.'
  .digest 'hex'
console.log digest
