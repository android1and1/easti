// Generated by CoffeeScript 2.1.1
(function() {
  var assert, flatten, mod, sample;

  assert = require('assert');

  mod = require('../share/flatten.js');

  sample = mod.sample;

  flatten = mod.flatten;

  describe('input and output::', function() {
    var oo;
    oo = [];
    before(function() {
      flatten(sample, oo, 0);
      console.log('///// Debug Info  //////////');
      console.log(oo);
      return console.log('///// End /////////');
    });
    it('should return an array', function() {
      //console.log '////////'
      return assert.ok(oo.length > 1);
    });
    return it('result array should has "item1" element::', function() {
      //assert oo.indexOf 'item6' isnt -1
      return assert((oo.indexOf('item1')) !== -1);
    });
  });

}).call(this);
