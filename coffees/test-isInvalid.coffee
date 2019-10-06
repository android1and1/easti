assert = require 'assert'
filter = require '../share/filter.js'

describe 'test non-words::',->
  it 'space should return false::',->
    assert.equal (filter ' '),false
  it 'empty should return false::',->
    assert.equal (filter ''),false
  it 'normal word should return true::',->
    assert.ok filter 'iamnormalword'
  it 'but two mormal words with a space should return false::',->
    assert.notEqual true,(filter 'one two')
