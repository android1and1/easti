assert = require 'assert'
mod = require '../share/flatten.js'
sample = mod.sample
flatten = mod.flatten
describe 'input and output::',->
  oo = [] 
  before ->
    flatten sample,oo,0
    console.log '''///// Debug Info  //////////'''
    console.log oo
    console.log '''///// End /////////'''

  it 'should return an array',->
    #console.log '////////'
    assert.ok oo.length > 1
  it 'result array should has "item1" element::',->
    #assert oo.indexOf 'item6' isnt -1
    assert (oo.indexOf 'item1') isnt -1
