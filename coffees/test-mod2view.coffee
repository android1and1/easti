RJ = require '../modules/md-reading-journals'
admin = require '../modules/md-admin.js'
assert = require 'assert'
describe 'From Module To View::',->
  describe 'Basic Test::',->
    it 'should be accessible::',->
      assert.equal admin.version,'1.0'
    it 'should has a function named "mod2view"::',->
      assert.ok admin.mod2view
    it 'mod2view() should output something::',->
      console.log admin.mod2view RJ
      assert.notEqual admin.mod2view(RJ).length,0 
