filter = function(be_dealt_with) {
    // return true is safe,return false means injectable.
    if(! be_dealt_with){
      return false;
    }
    return !/\W/.test(be_dealt_with);
  };
module.exports =   filter
   

