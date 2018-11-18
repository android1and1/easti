// Generated by CoffeeScript 2.3.1
(function() {
  var Nohm, NohmModel, ReadingJournals, nohm;

  Nohm = require('nohm');

  nohm = Nohm.Nohm;

  NohmModel = Nohm.NohmModel;

  ReadingJournals = (function() {
    class ReadingJournals extends NohmModel {
      static getDefinitions() {
        return ReadingJournals.definitions;
      }

    };

    ReadingJournals.modelName = 'readingjournals';

    ReadingJournals.idGenerator = 'increment';

    ReadingJournals.definitions = {
      title: {
        type: 'string',
        unique: true,
        validations: ['notEmpty']
      },
      author: {
        type: 'string',
        validations: ['notEmpty']
      },
      timestamp: {
        type: 'timestamp',
        defaultValue: 0
      },
      revision_info: {
        type: 'string'
      },
      journal: {
        type: 'string',
        validations: ['notEmpty']
      }
    };

    return ReadingJournals;

  }).call(this);

  module.exports = nohm.register(ReadingJournals);

}).call(this);
