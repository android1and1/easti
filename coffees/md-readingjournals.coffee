NohmModel = (require 'nohm').NohmModel
class ReadingJournals extends NohmModel
  @getDefinitions = ()=>
    @definitions

  @modelName = 'readingjournals'

  @idGenerator='increment'

  @definitions = {
    title:
      type:'string'
      unique:true
      validations:[
        'notEmpty'
      ]

    author:
      type:'string'
      validations:[
        'notEmpty'
      ]
       
    timestamp:
      type:'timestamp'
      defaultValue:0

    revision_info:
      type:'string'
      
    journal:{
      type:'string'
      validations:[
        'notEmpty'
      ]
    }
  }

module.exports = ReadingJournals
