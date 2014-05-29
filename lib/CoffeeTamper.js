(function() {
  var CSON, CoffeeTamper, assign, exists, extname, readFile, resolve, waterfall, _ref, _ref1;

  _ref = require('path'), extname = _ref.extname, resolve = _ref.resolve;

  _ref1 = require('fs'), readFile = _ref1.readFile, exists = _ref1.exists;

  waterfall = require('async').waterfall;

  CSON = require('cson');

  assign = require('lodash').assign;

  module.exports = CoffeeTamper = (function() {
    function CoffeeTamper() {}

    CoffeeTamper.prototype.run = function(options) {
      var tamperOptions;
      tamperOptions = {};
      return waterfall([
        (function(_this) {
          return function(next) {
            return _this.loadConfig(options.config, next);
          };
        })(this)
      ], function(err, configOptions) {
        if (err == null) {
          assign(tamperOptions, configOptions);
        }
        console.log(tamperOptions);
        return console.log('done');
      });
    };

    CoffeeTamper.prototype.loadConfig = function(path, callback) {
      var err;
      if (path == null) {
        callback(null, {});
        return;
      }
      switch (extname(path)) {
        case '.coffee':
          try {
            return callback(null, require(resolve('./', path)));
          } catch (_error) {
            err = _error;
            return callback(err);
          }
          break;
        case '.json':
          try {
            return callback(null, JSON.parse(readFileSync(path)));
          } catch (_error) {
            err = _error;
            return callback(err);
          }
          break;
        case '.cson':
          return CSON.parseFile(path, callback);
      }
    };

    return CoffeeTamper;

  })();

}).call(this);
