print = -> console.log(arguments...)

createConstructor = (getMethod) ->
	(size) ->
		dataList = []
		eventHandlers = {}

		fireEvent = (eventName, args) ->
			if (handlers = eventHandlers[eventName])
				for callback in handlers
					callback.apply(sq, args)

		sq = (elem) ->
			argc = arguments.length
			if argc == 0
				sq.get()
			else
				sq.add(arguments...)

		sq.push = sq.unshift = sq.add = (elem) ->
			argc = arguments.length
			if sq.maxSize && dataList.length + argc > sq.maxSize
				fireEvent('overflow', [arguments...])
			else
				dataList.push(arguments...)
			sq

		sq.pop = sq.shift = sq.get = ->
			removed = dataList[getMethod]()
			if dataList.length == 0
				fireEvent('empty')
			removed

		sq.peak = ->
			if getMethod == 'pop'
				dataList[dataList.length - 1]
			else
				dataList[0]

		sq.size = ->
			dataList.length

		sq.maxSize = size

		sq.on = (eventName, callback) ->
			if not (handlers = eventHandlers[eventName])
				handlers = eventHandlers[eventName] = []
			handlers.push(callback)
			sq

		sq.off = (eventName, callback) ->
			handlers = eventHandlers[eventName]
			for i in [0...handlers.length] when handlers[i] == callback
				handlers.splice(i, 1)

		sq.toString = ->
			dataList.toString()

		sq


root = exports ? this

root.Stack = Stack = createConstructor('pop')
root.Queue = Queue = createConstructor('shift')
