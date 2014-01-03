Stack-Queue
================

A JavaScript/CoffeeScript implementation of the basic stack and queue data structures which are safer than using a standard Array, as they only offer the core operations for adding and removing values.

A maximum size can be set for the structure and it will emit an overflow event when this is reached, which can be listening for by a callback function. It also emits an empty event when the last value is removed.

Usage
----------------

The new keyword is optional when creating an instance:
	
	var stack = Stack();
	var queue = new Queue();

Three alternative syntax conventions are available for the addition and removal operations:

 - Traditional JS Array methods:

		stack.push(7968, 123);
		stack.pop(); // returns 123

		queue.push(7968);
		queue.shift(); // returns 7968

 - Uniform add() and get() methods:

		stack.add(7968);
		stack.get(); // returns 7968

		queue.add(7968, 123);
		queue.get(); // returns 7968

 - Calling the structure as a function with arguments adds them. 
   Calling it without arguments removes the top value:

		stack(365);
		queue('foo', 'bar');

		stack(); // returns 365
		queue(); // returns 'foo'

All three conventions are interchangeable and semantically identical.

The top value can also be viewed without removing it using peek():

	stack.push('foo');
	stack.peek(); // returns 'foo'
	stack.pop(); // returns 'foo'

Get the number of values in the structure with size() and use maxSize to set an upper limit:

	stack.size();
	stack.maxSize = 10;

Add and remove listeners for the overflow and empty events with on() and off():

	var onOverflow = function(item) {
		console.log('Overflowed trying to add ', item);
	};

	// add listener
	stack.on('overflow', onOverflow); 

	// remove listener
	stack.off('overflow', onOverflow); 

	queue.on('emtpy', function() {
		console.log('The queue is empty');
	});