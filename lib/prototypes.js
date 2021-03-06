// Generated by CoffeeScript 1.4.0
var Specification;

Specification = require('./specification');

module.exports = {
  object: {
    set: {
      expect: function() {
        if (typeof Object.expect !== 'undefined') {
          return;
        }
        return Object.defineProperty(Object.prototype, 'expect', {
          get: function() {
            return function(config) {
              var expectation;
              if (typeof arguments[1] !== 'undefined') {
                throw 'Malformed expectation config... use <instance|ClassName>.expect <config>';
              }
              expectation = config;
              if (typeof config === 'string') {
                expectation = {};
                expectation[config] = {};
              }
              return Specification.create({
                "interface": this,
                config: expectation,
                realizer: 'PLACEHOLDER'
              });
            };
          }
        });
      },
      mock: function() {
        if (typeof Object.mock !== 'undefined') {
          return;
        }
        return Object.defineProperty(Object.prototype, 'mock', {
          get: function() {
            return function(className, config) {
              if (typeof className !== 'string') {
                throw 'Malformed mock config... use Object.mock \'MockObjectName\', <config>';
              }
              eval("this.klass = (function() {\n    function " + className + "() {}\n    return " + className + ";\n})();");
              if (config) {
                this.klass.expect(config);
              }
              return new this.klass;
            };
          }
        });
      }
    }
  }
};
