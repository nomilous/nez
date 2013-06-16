// Generated by CoffeeScript 1.4.0
var Confirmation, Specification;

require('fing');

Confirmation = require('./confirmation');

Specification = (function() {

  function Specification() {}

  Specification.objects = {};

  Specification.create = function(opts) {
    var config, confirmation, confirmations, edges, expectation, global, name, object, realizer, _base, _name;
    object = opts["interface"];
    config = opts.config;
    realizer = opts.realizer;
    try {
      global = object.process.title === 'node';
    } catch (error) {
      global = false;
    }
    if (global) {
      this.validateGlobals(config);
    }
    (_base = this.objects)[_name = object.fing.ref] || (_base[_name] = {
      "interface": object,
      global: global,
      confirmations: []
    });
    confirmations = this.objects[object.fing.ref].confirmations;
    if (!(edges = this.getNode().edges)) {
      throw "Cannot access current Node";
    }
    for (name in config) {
      expectation = {};
      expectation[name] = config[name];
      expectation[name].realizer = realizer;
      confirmation = new Confirmation(object, {
        expectation: expectation
      });
      confirmations.push(confirmation);
      edges.push(confirmation);
    }
    return this.objects[object.fing.ref].confirmations.push(confirmation);
  };

  Specification.validateGlobals = function(config) {
    var key, _results;
    _results = [];
    for (key in config) {
      if (key === 'beforeAll') {
        continue;
      }
      if (key === 'beforeEach') {
        continue;
      }
      if (key === 'afterAll') {
        continue;
      }
      if (key === 'afterEach') {
        continue;
      }
      throw 'Cannot create global specifications';
    }
    return _results;
  };

  Specification.getNode = function() {
    return require('./nez').stack.node;
  };

  return Specification;

})();

module.exports = Specification;