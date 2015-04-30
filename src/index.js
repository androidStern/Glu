var Glu = function () {
  'use strict';
  var _services = {},
      _resolved = {},
      _provided = {};

  function defineService (name, deps, factory) {
    delete _resolved[name];
    _services[name] = {
      deps: deps,
      factory: factory
    };
  }

  function resolveService (name) {
    var _seen = {};
    return resolve(name);
    function resolve (name) {
      if (_provided.hasOwnProperty(name)) { return _provided[name]; }
      if (_resolved.hasOwnProperty(name)) { return _resolved[name]; }
      if (_seen[name] === true) { throw 'Circular dependency detected resolving: ' + name; }
      _seen[name] = true;
      var service         = _services[name],
          deps            = service.deps.map(resolve);
          _resolved[name] = service.factory.apply(null, deps);
      return _resolved[name];
    }
  }
  
  return {
    define: function (name, deps, factory) {
      if (arguments.length > 2) {
        return defineService(name, deps, factory);
      }
      defineService(name, [], deps);
    },
    inject: function (deps, callback) {
      return callback.apply(null, deps.map(resolveService));
    },
    reset: function() {
      _resolved = {};
      _provided = {};
    },
    provide: function (name, obj) {
      _provided[name] = obj;
    }
  };
};

module.exports = Glu;