# just test env.
assert = require 'assert'
describe 'target is check enviroment about tdd(mocha)',->

  it 'one should equal one::',->
    assert.equal 1, 0 + 1 
