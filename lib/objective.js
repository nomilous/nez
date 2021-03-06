// Generated by CoffeeScript 1.4.0
var ActiveNode, Objective;

ActiveNode = require('./active_node');

module.exports = Objective = function(label, config, injectable) {
  var objectiveFile, path;
  try {
    if (typeof config.path === 'undefined') {
      objectiveFile = Error.apply(this).stack.split('\n')[3].match(/\((.*):\d*:\d*/)[1];
      path = require('path').dirname(objectiveFile);
      config.path = path;
    }
    if (typeof config.as === 'undefined') {
      config.as = 'Develop';
    }
    return new ActiveNode(label, config, injectable);
  } catch (error) {
    process.stderr.write('ERROR:' + error.message);
    return process.exit(1);
  }
};
