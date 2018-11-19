assert = require 'assert'
RJ = require '../modules/md-readingjournals.js'
describe 'From Module To View::',->
  describe 'Basic Test::',->
    it 'should be accessible::',->
      assert.equal RJ.version,'1.0'

    it 'should has a function named "mod2snippet"::',->
      assert.ok RJ.mod2snippet

    it 'mod2snippet() should output something::',->
      console.log RJ.mod2snippet()
      assert.notEqual RJ.mod2snippet().length,0 
