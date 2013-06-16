// Generated by CoffeeScript 1.4.0
var CoffeeScript, colors, link;

CoffeeScript = require('coffee-script');

colors = require('colors');

module.exports = link = {
  linker: function(opts) {
    if (typeof opts === 'string') {
      return link.fileLink(opts);
    }
  },
  fileLink: function(fileName) {
    var file, fs, js, line, match, source;
    fs = require('fs');
    if (fileName.match(/^\//)) {
      file = fileName;
    } else {
      file = link.fixPath(fileName);
    }
    try {
      source = fs.readFileSync(file).toString();
      js = CoffeeScript.compile(source, {
        bare: true
      });
    } catch (error) {
      if (match = error.message.match(/Parse error on line (\d*)/)) {
        line = match[1];
        link.showError(file, source, parseInt(line), error.message);
      }
    }
    return eval(js);
  },
  fixPath: function(fileName) {
    return "" + fileName + ".coffee";
  },
  showError: function(fileName, fileContents, lineNumber, message) {
    var line, lineNum, lines, num, start, _i;
    console.log("\nIN file: " + fileName.bold);
    console.log("ERROR:   " + message.red + "\n");
    lines = fileContents.split('\n');
    start = lineNumber - 5;
    for (num = _i = 1; _i <= 10; num = ++_i) {
      lineNum = start + num++;
      line = lines[lineNum];
      if (lineNum + 1 === lineNumber) {
        line = lines[lineNum].bold.red;
      }
      console.log("" + (lineNum + 1) + "  ", line);
    }
    return console.log('\n');
  }
};