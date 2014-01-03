// Generated by CoffeeScript 1.6.3
(function() {
  var Queue, Stack, createConstructor, print, root,
    __slice = [].slice;

  print = function() {
    return console.log.apply(console, arguments);
  };

  createConstructor = function(getMethod) {
    return function(size) {
      var dataList, eventHandlers, fireEvent, sq;
      dataList = [];
      eventHandlers = {};
      fireEvent = function(eventName, args) {
        var callback, handlers, _i, _len, _results;
        if ((handlers = eventHandlers[eventName])) {
          _results = [];
          for (_i = 0, _len = handlers.length; _i < _len; _i++) {
            callback = handlers[_i];
            _results.push(callback.apply(sq, args));
          }
          return _results;
        }
      };
      sq = function(elem) {
        var argc;
        argc = arguments.length;
        if (argc === 0) {
          return sq.get();
        } else {
          return sq.add.apply(sq, arguments);
        }
      };
      sq.push = sq.unshift = sq.add = function(elem) {
        var argc;
        argc = arguments.length;
        if (sq.maxSize && dataList.length + argc > sq.maxSize) {
          fireEvent('overflow', __slice.call(arguments));
        } else {
          dataList.push.apply(dataList, arguments);
        }
        return sq;
      };
      sq.pop = sq.shift = sq.get = function() {
        var removed;
        removed = dataList[getMethod]();
        if (dataList.length === 0) {
          fireEvent('empty');
        }
        return removed;
      };
      sq.peek = function() {
        if (getMethod === 'pop') {
          return dataList[dataList.length - 1];
        } else {
          return dataList[0];
        }
      };
      sq.size = function() {
        return dataList.length;
      };
      sq.maxSize = size;
      sq.on = function(eventName, callback) {
        var handlers;
        if (!(handlers = eventHandlers[eventName])) {
          handlers = eventHandlers[eventName] = [];
        }
        handlers.push(callback);
        return sq;
      };
      sq.off = function(eventName, callback) {
        var handlers, i, _i, _ref, _results;
        handlers = eventHandlers[eventName];
        _results = [];
        for (i = _i = 0, _ref = handlers.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (handlers[i] === callback) {
            _results.push(handlers.splice(i, 1));
          }
        }
        return _results;
      };
      sq.toString = function() {
        return dataList.toString();
      };
      return sq;
    };
  };

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.Stack = Stack = createConstructor('pop');

  root.Queue = Queue = createConstructor('shift');

}).call(this);