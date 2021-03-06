// Generated by CoffeeScript 1.4.0
var Exception, Node, PluginFactory, PluginRegister;

Node = require('./node');

Exception = require('./exception');

PluginRegister = require('./plugin_register');

module.exports = PluginFactory = {
  load: function(runtime, stack, config) {
    var module, plugin, scaffold;
    if (typeof config._module === 'undefined') {
      if (module = config._class.match(/^(.*):(.*)/).slice(1, 3)) {
        plugin = require(module[0])[module[1]];
      }
    } else {
      plugin = require(config._module);
    }
    plugin = PluginFactory.validate(plugin);
    scaffold = {
      label: stack.label,
      stack: stack.stack,
      emitter: {
        on: function() {
          return stack.on.apply(stack, arguments);
        }
      }
    };
    plugin.configure(runtime, scaffold, config);
    PluginRegister.register(plugin);
    return plugin;
  },
  validate: function(plugin) {
    var keyMatch, nodeType, _i, _j, _len, _len1, _ref, _ref1;
    if (typeof plugin.configure !== 'function') {
      throw Exception.create('INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin.configure()");
    }
    if (!(plugin.handles instanceof Array)) {
      throw Exception.create('INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.handles:[] array');
    }
    _ref = plugin.handles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      nodeType = _ref[_i];
      if (typeof plugin[nodeType] !== 'function') {
        throw Exception.create('INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin." + nodeType + "() handler");
      }
    }
    if (!(plugin.matches instanceof Array)) {
      throw Exception.create('INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.matches:[] array');
    }
    _ref1 = plugin.matches;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      keyMatch = _ref1[_j];
      if (typeof plugin[keyMatch] !== 'function') {
        throw Exception.create('INVALID_PLUGIN', "INVALID_PLUGIN - Undefined Plugin." + keyMatch + "() matcher");
      }
    }
    if (typeof plugin.hup !== 'function') {
      throw Exception.create('INVALID_PLUGIN', 'INVALID_PLUGIN - Undefined Plugin.hup()');
    }
    return plugin;
  }
};
