// Generated by CoffeeScript 1.6.3
var Notice, Objective, Phrase;

Notice = require('notice');

Phrase = require('phrase');

Objective = require('./objective');

module.exports = function(opts, objectiveFn) {
  var Module, error, localopts, missing, required;
  missing = (function() {
    var _i, _len, _ref, _results;
    _ref = ['title', 'uuid', 'description'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      required = _ref[_i];
      if (opts[required] != null) {
        continue;
      }
      _results.push(required);
    }
    return _results;
  })();
  if (missing.length > 0) {
    console.log("objective(opts, objectiveFn) requires " + (missing.map(function(p) {
      return "opts." + p;
    }).join(', ')));
    process.exit(1);
  }
  localopts = {
    module: opts.module || '../defaults',
    "class": opts["class"] || 'Develop'
  };
  try {
    Module = require(localopts.module);
    if (Module[localopts["class"]] == null) {
      throw new Error("Could not initialize objective module(=" + localopts.module + ") does not define class(=" + localopts["class"] + ")");
    }
    Objective = Module[localopts["class"]];
  } catch (_error) {
    error = _error;
    try {
      delete opts.listen.secret;
    } catch (_error) {}
    try {
      delete opts.listening;
    } catch (_error) {}
    console.log({
      OPTS: opts,
      ERROR: error
    });
    process.exit(2);
  }
  return Notice.listen("objective/" + opts.uuid, opts, function(error, realizerHub) {
    var objective, recursor;
    if (error != null) {
      try {
        delete opts.listen.secret;
      } catch (_error) {}
      try {
        delete opts.listening;
      } catch (_error) {}
      console.log({
        OPTS: opts,
        ERROR: error
      });
      process.exit(3);
    }
    objective = new Objective;
    try {
      recursor = Phrase.createRoot(opts, function(objectiveToken, objectiveNotice) {
        return objectiveToken.on('ready', function(_arg) {
          var tokens;
          tokens = _arg.tokens;
          return objective.startMonitor({}, tokens, function(token, opts) {
            return objectiveToken.run(token, opts);
          });
        });
      });
      return recursor('objective', objectiveFn || objective.defaultObjective);
    } catch (_error) {
      error = _error;
      try {
        delete opts.listen.secret;
      } catch (_error) {}
      try {
        delete opts.listening;
      } catch (_error) {}
      console.log({
        OPTS: opts,
        ERROR: error
      });
      return process.exit(4);
    }
  });
};