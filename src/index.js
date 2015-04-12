var Glu = function () {
  'use strict';
  var _services = {};
  var _resolved = {};

  function defineService (name, deps, factory) {
    delete _resolved[name];
    _services[name] = {
      deps: deps,
      factory: factory
    };
  }

  function define (name, deps, factory) {
    if (arguments.length > 2) {
      return defineService(name, deps, factory);
    }
    defineService(name, [], deps);
  }

  function resolveService (name) {
    if (_resolved.hasOwnProperty(name)) {
      return _resolved[name];
    }
    var service = _services[name],
        deps    = service.deps.map(resolveService);
    return service.factory.apply(null, deps);
  }

  function inject (deps, callback) {
    return callback.apply(null, deps.map(resolveService));
  }
  
  return {
    define: define,
    inject: inject
  };
};

module.exports = Glu;