// Generated by CoffeeScript 1.4.0
var ActiveNode, Defaults, Http, Injector, Plex, PluginLoader, Runtime, Stack;

Defaults = require('./defaults');

PluginLoader = require('./plugin_loader');

Injector = require('nezcore').injector;

Runtime = require('nezcore').runtime;

Stack = require('./stack');

Http = require('http');

Plex = require('plex');

module.exports = ActiveNode = (function() {

  function ActiveNode(label, config, injectable) {
    var tags,
      _this = this;
    this.label = label;
    this.config = config != null ? config : {};
    this.injectable = injectable != null ? injectable : function() {};
    this.config._runtime = new Runtime();
    this.logger = this.config._runtime.logger;
    this.nodeID = process.env.NODE_ID;
    tags = process.env.NODE_TAGS || '';
    this.tags = tags.split(' ');
    this.logger.log({
      verbose: function() {
        return {
          'active config query': {
            as: _this.config.as || process.env.NODE_AS,
            path: _this.config.path,
            nodeID: _this.nodeID,
            tags: _this.tags
          }
        };
      }
    });
    this.outerValidate();
    this.config.as(this.nodeID, this.tags, function(error, activeConfig) {
      _this.logger.log({
        verbose: function() {
          return {
            'active config result': {
              config: activeConfig
            }
          };
        }
      });
      _this.innerValidate(activeConfig);
      return _this.start(activeConfig);
    });
  }

  ActiveNode.prototype.start = function(activeConfig) {
    var listen, match, plexConfig, server, service, services, stacker, type, validate, _i, _len, _ref,
      _this = this;
    if (typeof activeConfig._objective !== 'undefined') {
      type = '_objective';
    } else if (typeof activeConfig._realizer !== 'undefined') {
      type = '_realizer';
    } else {
      throw new Error("ActiveNode should be an Objective or a Realizer");
    }
    this.logger.info(function() {
      return {
        'starting active node': {
          "class": activeConfig[type]["class"],
          label: _this.label,
          category: _this.config.category
        }
      };
    });
    this.stack = new Stack(this);
    this.config._class = activeConfig[type]["class"];
    this.plugin = PluginLoader.load(this.config._runtime, this.stack, this.config);
    if (type === '_objective') {
      if (typeof activeConfig._plex !== 'undefined') {
        server = Http.createServer();
        listen = this.config._runtime.listen;
        server.listen(listen.port, listen.iface, function() {
          _this.logger.info(function() {
            return {
              'listening for realizers': {
                iface: server.address().address,
                port: server.address().port
              }
            };
          });
          return _this.plugin.monitor(function(error, action) {
            if (error) {
              _this.logger.error(function() {
                return {
                  'objective monitor error': {
                    error: error
                  }
                };
              });
            }
            if (action) {
              return _this.logger.info(function() {
                return {
                  'call action': {
                    action: action
                  }
                };
              });
            }
          });
        });
        activeConfig._plex.listen = {
          adaptor: listen.adaptor,
          server: server
        };
      }
    }
    if (typeof activeConfig._plex !== 'undefined') {
      plexConfig = activeConfig._plex;
      if (!plexConfig.logger) {
        plexConfig.logger = this.logger;
      }
      plexConfig.protocol = this.plugin.bind;
      plexConfig.connect = this.config._runtime.connect;
      this.plex = Plex.start(plexConfig);
    }
    services = [];
    stacker = function() {
      return _this.stack.stacker.apply(_this.stack, arguments);
    };
    stacker.link = this.stack.stacker.link;
    services.push(stacker);
    if (type === '_realizer') {
      validate = function() {
        return _this.stack.validate.apply(_this.stack, arguments);
      };
      services.push(validate);
    }
    if (typeof this.config["with"] !== 'undefined') {
      _ref = this.config["with"];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        service = _ref[_i];
        if (typeof service !== 'string') {
          services.push(service);
          continue;
        }
        try {
          if (match = service.match(/^(.*):(.*)$/)) {
            services.push(Injector.support.findModule({
              module: match[1]
            })[match[2]]);
          } else {
            services.push(Injector.support.findModule({
              module: service
            }));
          }
        } catch (error) {
          this.logger.error(function() {
            return "error loading service '" + service + "'";
          });
          services.push(void 0);
        }
      }
    }
    if (typeof this.injectable === 'function') {
      Injector.inject(services, this.injectable);
      if (type === '_realizer') {
        return this.plex.stop();
      }
    }
  };

  ActiveNode.prototype.innerValidate = function(config) {};

  ActiveNode.prototype.outerValidate = function() {
    var match,
      _this = this;
    if (typeof this.label !== 'string') {
      throw new Error("ActiveNode requires 'label' string as arg1");
    }
    if (typeof this.config.as === 'undefined') {
      this.config.as = process.env.NODE_AS;
    }
    if (typeof this.config.as === 'string') {
      if (typeof Defaults[this.config.as] !== 'undefined') {
        return this.config.as = Defaults[this.config.as];
      } else {
        try {
          if (match = this.config.as.match(/^(.*):(.*)$/)) {
            return this.config.as = require(match[1])[match[2]];
          } else {
            return this.config.as = require(this.config.as);
          }
        } catch (error) {
          this.logger.error(function() {
            return "active config lookup failed for '" + _this.config.as + "'";
          });
          throw error;
        }
      }
    }
  };

  return ActiveNode;

})();