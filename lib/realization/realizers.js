// Generated by CoffeeScript 1.6.3
exports.createCollection = function(π) {
  var error;
  return new ((function() {
    try {
      if (π.controller != null) {
        return require(π.controller);
      } else {
        return require('./controller');
      }
    } catch (_error) {
      error = _error;
      try {
        delete π.listen.secret;
      } catch (_error) {}
      try {
        delete π.listening;
      } catch (_error) {}
      console.log({
        OPTS: π,
        ERROR: error
      });
      return process.exit(4);
    }
  })())(π);
};