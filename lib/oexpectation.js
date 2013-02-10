// Generated by CoffeeScript 1.4.0
var Expectation, Realization;

Realization = require('./realization');

module.exports = Expectation = (function() {

  Expectation.prototype.className = 'Expectation';

  function Expectation(config) {
    var expectationType, key, name, opts, type;
    if (config == null) {
      config = {};
    }
    expectationType = 'createFunction';
    name = void 0;
    for (key in config.opts) {
      name = key;
      break;
    }
    if (!name) {
      throw 'Malformed Expectation';
    }
    opts = config.opts[name];
    type = opts.as;
    switch (type) {
      case 'spy':
        if (!(config.object[name] || (config.object.prototype && config.object.prototype[name]))) {
          console.log('WARNING: spy on non existant function %s(...)', name);
        }
        break;
      case 'get':
      case 'set':
        expectationType = 'createProperty';
    }
    this.realization = new Realization(config.object);
    this.realization[expectationType](name, opts);
  }

  return Expectation;

})();