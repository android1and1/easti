crypto = require 'crypto'
sha256 = crypto.createHash 'sha256'
digest = sha256.update '1234567'
  .digest 'hex'
console.log digest
