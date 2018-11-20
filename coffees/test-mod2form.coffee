assert = require 'assert'
RJ = require '../modules/md-readingjournals.js'
describe 'From Module To View::',->
  describe 'Basic Test::',->
    it 'should be accessible::',->
      assert.equal RJ.version,'1.0'

    it 'should has a function named "mod2form"::',->
      assert.ok RJ.mod2form

    it 'mod2form() should output something::',->
      console.log RJ.mod2form()
      assert.notEqual RJ.mod2form().length,0 
