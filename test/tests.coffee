if require?
	sq = require('../stack-queue.js')
	global.Stack = sq.Stack
	global.Queue = sq.Queue

assert = 
	equal: (x, y) ->
		if x != y
			throw Error("assertion failed: #{x} does not equal #{y}")
	false: (x) ->
		if x != false
			throw Error("assertion failed: #{x} should be false")
	true: (x) ->
		if x != true
			throw Error("assertion failed: #{x} should be true")

describe 'Basic Methods', ->
	describe 'stack(value) / stack.push(value) / stack.add(value)', ->
		it 'should increment size with each new value from call to self', ->
			stack = Stack()
			before = stack.size()
			stack('foo')
			stack('bar')
			after = stack.size()
			assert.equal(before, 0)
			assert.equal(after, 2)

		it 'should increment size with each new value from call to push', ->
			stack = Stack()
			before = stack.size()
			stack.push('foo', 'bar', 'boo')
			after = stack.size()
			assert.equal(before, 0)
			assert.equal(after, 3)

		it 'should increment size with each new value from call to add', ->
			stack = Stack()
			before = stack.size()
			stack.add('foo')
			after = stack.size()
			assert.equal(before, 0)
			assert.equal(after, 1)

	describe 'stack() / stack.pop() / stack.get()', ->
		it 'should decrement size with each call to stack()', ->
			stack = Stack()('foo')
			before = stack.size()
			stack()
			stack()
			after = stack.size()
			assert.equal(before, 1)
			assert.equal(after, 0)

		it 'should decrement size with each call to stack.pop()', ->
			stack = Stack()('foo', 'bar')
			before = stack.size()
			stack.pop()
			after = stack.size()
			assert.equal(before, 2)
			assert.equal(after, 1)

		it 'should decrement size with each call to stack.get()', ->
			stack = Stack()('foo', 'bar', 'boo')
			before = stack.size()
			stack.get()
			stack.get()
			after = stack.size()
			assert.equal(before, 3)
			assert.equal(after, 1)

		it 'should return undefined when the stack is empty', ->
			stack = Stack()
			assert.equal(stack.get(), undefined)
			stack.add('foo').get()
			assert.equal(stack.get(), undefined)

	describe 'stack.toString()', ->
		it 'should return the same string as Array.toString()', ->
			stack = Stack()
			a = [124, 'foo', 564]
			stack.push(a...)
			assert.equal(stack.toString(), a.toString())

describe 'Stack Specific Methods', ->
	it 'should return values in FILO order', ->
		data = [34, 48, 19]
		stack = Stack()
		stack(data[0]).push(data[1]).add(data[2])
		assert.equal(stack(), data[2])
		assert.equal(stack.pop(), data[1])
		assert.equal(stack.get(), data[0])

	describe 'stack.peak()', ->
		it 'should return last value without mutating the stack', ->
			data = [34, 48, 19]
			stack = Stack()(data...)
			assert.equal(stack.peak(), data[2])
			assert.equal(stack.peak(), stack())
			assert.equal(stack.peak(), data[1])

describe 'Queue Specific Methods', ->
	it 'should return values in FIFO order', ->
		data = [34, 48, 19]
		queue = Queue()
		queue(data[0]).push(data[1]).add(data[2])
		assert.equal(queue(), data[0])
		assert.equal(queue.shift(), data[1])
		assert.equal(queue.get(), data[2])

	describe 'queue.peak()', ->
		it 'should return first value without mutating the queue', ->
			data = [34, 48, 19]
			queue = Queue()(data...)
			assert.equal(queue.peak(), data[0])
			assert.equal(queue.peak(), queue())
			assert.equal(queue.peak(), data[1])

describe 'Events', ->
	describe 'overflow', ->
		it 'should fire overflow event when maxSize is reached', ->
			fired = false
			queue = Queue(5).on 'overflow', ->
				fired = true
			queue(12, 45, 29, 'foo', 'bar')
			assert.false(fired)
			queue(334)
			assert.true(fired)

		it 'should pass value which was added to overflow handler', ->
			overflowValue = 344
			queue = Queue(3)(12, 45, 29).on 'overflow', (value) ->
				assert.equal(value, overflowValue)
			queue(overflowValue)

	describe 'empty', ->
		it 'should fire empty event when last value is removed', ->
			fired = false
			queue = Queue(5).on 'empty', ->
				fired = true
			queue(12, 45)
			queue()
			assert.false(fired)
			queue()
			assert.true(fired)

	describe 'queue.on(eventName, callback)', ->
		it 'should allow multiple callbacks for the same event', ->
			firedCounts = [0, 0]
			queue = Queue(5).on 'empty', ->
				firedCounts[0]++
			queue.on 'empty', ->
				firedCounts[1]++
			queue(7)()
			queue()
			assert.equal(firedCounts[0], firedCounts[1])

	describe 'queue.off(eventName, callback)', ->
		it 'should not call callback after it has been removed', ->
			firedCount = 0
			callback = -> firedCount++
			queue = Queue(5).on('empty', callback)
			queue(15)()
			queue.off('empty', callback)
			queue(12)()
			assert.equal(firedCount, 1)