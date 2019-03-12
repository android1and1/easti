/* 
 bin/www.js will require this,like below:
 require '../daka-ruler.js' 
*/

ruler = {
  am: {
    // 北京时间上午7:25-7:45
    first_half: {
      hour:23, // utc23=7:00AM(cst),
      minutes: {min:25, max:45},
    },
    second_half:null,
  },
  pm:{
    // 北京时间下午17:50 - 18:10
    first_half: {
      hour:9, // utc9=17:00PM
      minutes: {min:50, max:59}
    },
    second_half:{
      hour:10,// utc10=18:00PM
      minutes:{min:0, max:10}
    },
  },
}
    
module.exports = ruler
