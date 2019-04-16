nums = [48..57]        # digits 0..9
alpha = [97...97+26] # from 'a' to 'z'
{round,random} = Math

chars = nums.concat alpha
  .concat nums
  .concat alpha
assert = require 'assert'
assert.equal chars.length,10*2 + 26*2


console.log 'x xx'.repeat 11
# do 4 times
words = for _ in [1..4]
  # chars.length is 72,so index max 71(72-1)
  index =  round random() * (72-1)  
  char = String.fromCharCode chars[index]
console.log words
  
   
