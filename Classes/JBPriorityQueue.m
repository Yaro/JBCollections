#import "JBPriorityQueue.h"

@interface JBPriorityQueue()

- (void) grow : (NSInteger) minCapacity;
- (void) siftUp : (NSInteger) i object: (id) o;
- (void) siftDown : (NSInteger) i object: (id) o;
- (void) siftUpWithComparator: (NSInteger) i object: (id) o;
- (void) siftDownWithComparator: (NSInteger) i object: (id) o;

@end



@implementation JBPriorityQueue

@synthesize size = mySize;

- (void) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp {
	myComparator = [comp copy];
	myQueue = arrayWithLength(capacity);
	myLength = capacity;
	mySize = 0;
}

- (void) clear {
	for (int i = 0; i < mySize; i++)
		[myQueue[i] release];
	//deleteArray(myQueue);
}

- (BOOL) add: (id) o {
	[o retain];
	if (mySize >= myLength)
		[self grow: myLength];
	myQueue[mySize++] = o;
	[self siftUp: (mySize - 1) object: o];
	return TRUE;
}

- (id) peek {
	return mySize > 0 ? myQueue[0] : nil;
}

- (id) poll {
	if (mySize <= 0) return nil;
	id ret = myQueue[0];
	mySize--;
	[self siftDown:0 object:myQueue[mySize]];
	[ret release];
	return ret;
}

- (void) grow : (NSInteger) minCapacity {
	id* nQueue = arrayWithLength((minCapacity + 5) * 3 / 2);
	copyAt(nQueue, 0, myQueue, mySize);
	deleteArray(myQueue);
	myQueue = nQueue;
}
		   
- (void) siftUp : (NSInteger) i object: (id) o {
	if (myComparator)
		[self siftUpWithComparator: i object: o];
	else {};
}

- (void) siftDown : (NSInteger) i object: (id) o {
	if (myComparator)
		[self siftDownWithComparator: i object: o];
	else {};
}

- (void) siftUpWithComparator: (NSInteger) i object: (id) o {
	while (i > 0) {
		NSInteger pi = (i - 1) >> 1;
		id parent = myQueue[pi];
		if (myComparator(parent, o) == NSOrderedDescending) {
			myQueue[i] = parent;
		}
		i = pi;
	}
}

- (void) siftDownWithComparator: (NSInteger) i object: (id) o {
	while ((i + 1) << 1 < mySize) {
		NSInteger ci = (i << 1) + 1;
		id child = myQueue[ci];
		NSInteger ri = ci + 1;
		if (ri < mySize && myComparator(child, myQueue[ri]) == NSOrderedDescending) {
			ci = ri;
			child = myQueue[ri];
		}
		if (myComparator(o, child) == NSOrderedAscending) break;
		myQueue[i] = child;
		i = ci;
	}
	myQueue[i] = o;
}

- (void) heapify {
	int maxToHeapify = mySize >> 1;
	for (int i = 0; i < maxToHeapify; i++)
		[self siftDown: i object: myQueue[i]];
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= mySize) return nil;
		return myQueue[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	}] autorelease];
}

@end