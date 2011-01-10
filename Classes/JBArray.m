#import "JBArray.h"
#import "JBArrays.h"



/*void swap(id* a, id* b) {
	id x = *a;
	*a = *b;
	*b = x;
}*/

int randInt(int l, int r) {
	return (int)(rand() % (r - l + 1) + l);
}

inline static void rangeCheck(JBArray* arr, NSInteger i) {
	if (i < 0 || i >= arr.length) {
		@throw [JBExceptions indexOutOfBounds: i size: arr.length];
	}
}



@interface JBArray()

- (void) sort: (NSComparator) cmp left: (int) l right: (int) r;

@end


@implementation JBArray

@synthesize length = myLength;

- (id) initWithSize: (NSInteger) n {
	[super init];
	myLength = n;
	myArray = arrayWithLength(n);
	return self;
}

- (id) init {
	@throw [JBExceptions unsupportedOperation];
}

+ (JBArray*) withSize: (NSInteger) n {
	JBArray* ret = [[JBArray alloc] initWithSize: n];
	return [ret autorelease];
}

+ (JBArray*) withObjects: (id) firstObject, ... {
	id object;
	va_list argumentList;
	int size = 0;
	if (firstObject) {
		size++;
		va_start(argumentList, firstObject);
		while (va_arg(argumentList, id)) {
			size++;
		}
		va_end(argumentList);
	}
	JBArray* ret = [[JBArray withSize: size] retain];
	
	int index = 0;
	if (firstObject) {
		ret->myArray[index++] = [firstObject retain];
		va_start(argumentList, firstObject);
		while (object = va_arg(argumentList, id)) {
			ret->myArray[index++] = [object retain];
		}
	}
	return [ret autorelease];
}

- (id) set: (id) object at: (NSInteger) i {
	rangeCheck(self, i);
	id ret = myArray[i];
	myArray[i] = [object retain];
	return [ret autorelease];
}

- (id) get: (NSInteger) i {
	rangeCheck(self, i);
	return myArray[i];
}

- (BOOL) contains: (id) o {
	for (int i = 0; i < myLength; i++) {
		if ([myArray[i] isEqual: o]) {
			return TRUE;
		}
	}
	return FALSE;
}

- (id) removeAt: (NSInteger) index {
	return [self set: nil at: index];
}

- (void) clear {
	for (int i = 0; i < myLength; i++) {
		[myArray[i] release];
		myArray[i] = nil;
	}
}

- (void) dealloc {
	[self clear];
	deleteArray(myArray);
	[super dealloc];
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= myLength) {
			@throw [JBAbstractIterator noSuchElement];
		}
		return myArray[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < myLength;
	} removeCL: ^void(void) {
		if (cursor > 0) {
			[self removeAt: cursor - 1];
		} else {
			@throw [JBAbstractIterator badRemove];
		}
	}] autorelease];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	if (state->state == 0) {
		state->mutationsPtr = &(state->extra[0]);
	}
	NSInteger i = 0;
	state->itemsPtr = stackbuf;
	for (i = 0; i < len; i++) {
		if (state->state >= myLength) {
			return i;
		}
		stackbuf[i] = myArray[state->state++];
	}
	return i;
}

- (id*) toArray {
	return copyOf(myArray, myLength);
}

- (NSUInteger) size {
	return myLength;
}

- (void) sort: (NSComparator) cmp left: (int) l right: (int) r {
	if (l >= r) return;
	int xi = randInt(l, r);
	id x = myArray[xi], t;
	int bl = l, br = r, bm = l;
	while (bm <= br) {
		NSComparisonResult res = cmp(myArray[bm], x);
		if (res == NSOrderedAscending) {
			t = myArray[bl], myArray[bl] = myArray[bm], myArray[bm] = t;
			bl++;
			bm++;
		} else if (res == NSOrderedDescending) {
			t = myArray[bm], myArray[bm] = myArray[br], myArray[br] = t;
			br--;
		} else {
			bm++;
		}
	}
	[self sort: cmp left: l right: bl - 1];
	[self sort: cmp left: bm right: r];
}

- (void) sort: (NSComparator) cmp {
	[self sort: cmp left: 0 right: myLength - 1];
}

@end

