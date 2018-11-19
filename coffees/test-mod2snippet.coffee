assert = require 'assert'
RJ = require '../modules/md-readingjournals.js'
admin = require '../modules/md-admin-readingjournals.js'
describe 'From Module To View::',->
  describe 'Basic Test::',->
    it 'should be accessible::',->
      assert.equal admin.version,'1.0'

    it 'should has a function named "mod2snippet"::',->
      assert.ok admin.mod2snippet

    it 'mod2snippet() should output something::',->
      console.log admin.mod2snippet RJ
      assert.notEqual admin.mod2snippet(RJ).length,0 
