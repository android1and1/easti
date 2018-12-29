assert = require 'assert'
nohm = require 'nohm'
Nohm = nohm.Nohm
NohmModel = nohm.NohmModel 
db = undefined
Schema = undefined

class Password extends NohmModel
  @idGenerator = 'increment'
  @modelName = 'pass'
  @definitions = {
    for_what:
      type:'string'
      index:true
      validations:['notEmpty'] 
    pair_text:
      type:'string'
      validations:['notEmpty'] 
    update_time:
      type:'timestamp'
      defaultValue: Date.now()
    visits:
      defaultValue:0
      load_pure:true
      type:(newv,key,oldv)->
        # nohm will treat 'oldv' and 'newv' as string,so need parseInt()
        parseInt(oldv) + 1
  }


  
describe 'Mocha + Nohm::',->
  client = (require 'redis').createClient()

  client.on 'error',(err)->
    console.log '\tPlease Check Redis Process,Api Said:\n"%s."\n',err.message 
    process.exit 1

  client.on 'connect',->
    Nohm.setClient @
    Nohm.setPrefix 'laofu' # lao fu
    # Dont Forget Register!
    Schema = Nohm.register Password 
    db = new Schema
  describe 'Store Instance As One Item::',->
    before ->
      Nohm.purgeDb client

    it 'should has nothing initial time::',->
      db.find().then (something)-> 
        assert.equal something.length,0

    it 'should store 1 item::',->
      db.property 'for_what','Mac System'
      db.property 'pair_text','mac-user:chilemeiyou(chi le mei you)'
      db.property 'visits','Am I?'
      db.save().then (something)->
        assert.equal db.id,'1'
 
    it 'should has one item and its property-visits is 1::',->
      db.find().then (something)->
        item = await db.load something[0]
        assert.equal item.visits,1

    it 'above item updated then its visits will add 1::',->
      db.property 'visits','any'
      await db.save()
      ids = await db.find {'for_what':'Mac System'}
      id = ids[0]
      item = await db.load id
      assert.equal item.visits,2
       
    it 'above item updated 3 times then its visits value is 5::',->
      for i in [1..3]
        db.property 'visits',''
        await db.save()
      ids = await db.find {'for_what':'Mac System'}
      id = ids[0]
      item = await db.load id
      assert.equal item.visits,5
    it 'should valide fail because pair_text not given::',->
      db2 = new Schema
      db2.property 
        for_what:'Jelly-Mac System'
        pair_text:'root:123'
        update_time:'2013-5-9 14:00:28'
      db2.save().then (ins)->
        assert.equal db2.id,2
