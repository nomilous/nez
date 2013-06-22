// Generated by CoffeeScript 1.6.3
var Notice, collection, factory;

Notice = require('notice');

collection = {};

factory = function(context, notice, callback) {
  return Notice.listen('realizers', context, function(error) {
    var realizers;
    if (error != null) {
      return callback(error);
    }
    realizers = {
      task: function(title, ref) {
        return realizers.get(ref, function(err, realizer) {
          return realizer.task(title);
        });
      },
      get: function(ref, callback) {
        if (!((ref != null) && (ref.id != null))) {
          throw new Error('realizers.get(ref, callback) requires ref.id as the realizer id');
        }
        if (collection[ref.id] == null) {
          if (ref.script == null) {
            return callback(new Error('missing realizer'));
          }
          if (ref.script.match(/\.(lit)*coffee$/) == null) {
            return callback(new Error('nez supports only coffee-script realizers'));
          }
          return context.tools.spawn(ref, callback);
        }
      }
    };
    return callback(null, realizers);
  });
};

module.exports = factory;