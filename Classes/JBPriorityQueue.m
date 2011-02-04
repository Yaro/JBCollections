#import "JBPriorityQueue.h"

@interface JBPriorityQueue()

- (void) grow: (NSInteger) minCapacity;
- (void) siftUp: (NSInteger) i object: (id) o;
- (void) siftDown: (NSInteger) i object: (id) o;
- (void) siftEmpty: (NSInteger) i;

@end



@implementation JBPriorityQueue

@synthesize size = mySize, comparator = myComparator;

- (id) init {
	@throw [JBExceptions needComparator];
}

+ (id) withObjects: (id) firstObject, ... {
	@throw [JBExceptions needComparator];
}

- (id) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp {
	[super init];
	myComparator = [comp copy];
	myQueue = arrayWithLength(capacity);
	myLength = capacity;
	mySize = 0;
	return self;
}

+ (id) withCapacity: (NSInteger) capacity comparator: (NSComparator) comp {
	return [[[self alloc] initWithCapacity: capacity comparator: comp] autorelease];
}

- (id) initWithComparator: (NSComparator) comp {
	return [self initWithCapacity: 10 comparator: comp];
}

+ (id) withComparator: (NSComparator) comp {
	return [[[self alloc] initWithComparator: comp] autorelease];
}

+ (id) withCollection: (id<JBCollection>) c {
	if (![(id)c conformsToProtocol: @protocol(JBComparatorRequired)]) {
		@throw [JBExceptions needComparator];
	}
	id ret = [self withComparator: [(<JBComparatorRequired>)c comparator]];
	[ret addAll: c];
	return ret;
}

- (void) clear {
	for (int i = 0; i < mySize; i++) {
		[myQueue[i] release];
	}
}

- (void) dealloc {
	[self clear];
	deleteArray(myQueue);
	[super dealloc];
}

- (BOOL) add: (id) o {
	[o retain];
	if (mySize >= myLength) {
		[self grow: myLength];
	}
	myQueue[mySize++] = o;
	[self siftUp: (mySize - 1) object: o];
	return YES;
}

- (BOOL) remove: (id) o {
	for (int i = 0; i < mySize; i++) {
		if ([myQueue[i] isEqual: o]) {
			[self siftEmpty: i];
			mySize--;
			return YES;
		}
	}
	return NO;
}

- (id) peek {
	return mySize > 0 ? myQueue[0] : nil;
}

- (id) poll {
	if (mySize <= 0) return nil;
	id ret = myQueue[0];
	mySize--;
	[self siftDown: 0 object: myQueue[mySize]];
	return [ret autorelease];
}

- (void) grow: (NSInteger) minCapacity {
	myLength = (minCapacity + 5) * 3 / 2;
	myQueue = resizeArray(myQueue, myLength);
}

- (void) siftUp: (NSInteger) i object: (id) o {
	while (i > 0) {
		NSInteger pi = (i - 1) >> 1;
		id parent = myQueue[pi];
		if (myComparator(parent, o) == NSOrderedDescending) {
			myQueue[i] = parent;
			i = pi;
		} else {
			break;
		}
	}
	myQueue[i] = o;
}


- (void) siftEmpty: (NSInteger) i {
	while ((i << 1) + 1 < mySize) {
		NSInteger ci = (i << 1) + 1;
		NSInteger ri = ci + 1;
		if (ri < mySize && myComparator(myQueue[ci], myQueue[ri]) == NSOrderedDescending) {
			ci = ri;
		}
		myQueue[i] = myQueue[ci];
		i = ci;
	}
	myQueue[i] = nil;
}

- (void) siftDown: (NSInteger) i object: (id) o {
	while ((i << 1) + 1 < mySize) {
		NSInteger ci = (i << 1) + 1;
		id child = myQueue[ci];
		NSInteger ri = ci + 1;
		if (ri < mySize && myComparator(child, myQueue[ri]) == NSOrderedDescending) {
			ci = ri;
			child = myQueue[ri];
		}
		if (myComparator(o, child) == NSOrderedAscending) {
			break;
		}
		myQueue[i] = child;
		i = ci;
	}
	myQueue[i] = o;
}

- (void) heapify {
	int maxToHeapify = mySize >> 1;
	for (int i = 0; i < maxToHeapify; i++) {
		[self siftDown: i object: myQueue[i]];
	}
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= mySize) {
			@throw [JBAbstractIterator noSuchElement];
		}
		return myQueue[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	}] autorelease];
}

@end