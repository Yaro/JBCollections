#import "JBArray.h"
#import "JBCollections.h"

#define rangeCheck(i) if (i < 0 || i >= mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];

static int randInt(int l, int r) {
	return rand() % (r - l + 1) + l;
}


@implementation JBArray

@synthesize size = mySize;

- (id) initWithSize: (NSInteger) n {
	[super init];
	mySize = n;
	myArray = calloc(n, sizeof(id));
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
	rangeCheck(i);
	id ret = myArray[i];
	myArray[i] = [object retain];
	return [ret autorelease];
}

- (id) get: (NSInteger) i {
	rangeCheck(i);
	return myArray[i];
}

- (BOOL) contains: (id) o {
	for (int i = 0; i < mySize; i++) {
		if (equals(o, myArray[i])) {
			return YES;
		}
	}
	return NO;
}

- (int) indexOf: (id) o {
	for (int i = 0; i < mySize; i++) {
		if (equals(o, myArray[i])) {
			return i;
		}
	}
	return NSNotFound;		
}

- (id) removeAt: (NSInteger) index {
	return [self set: nil at: index];
}

- (void) clear {
	for (int i = 0; i < mySize; i++) {
		[myArray[i] release];
		myArray[i] = nil;
	}
}

- (void) dealloc {
	[self clear];
	free(myArray);
	[super dealloc];
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= mySize) {
			@throw [JBAbstractIterator noSuchElement];
		}
		return myArray[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
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
		state->itemsPtr = myArray;
		state->state = 1;
		return mySize;
	} else return 0;
}

- (id) initWithCArray: (id*) array size: (NSInteger) nsize {
	[super init];
	myArray = array;
	mySize = nsize;
	for (int i = 0; i < mySize; i++) {
		[myArray[i] retain];
	}
	return self;
}

- (JBArray*) subarray: (NSRange) range {
	rangeCheck(range.location);
	rangeCheck(range.location + range.length - 1);
	id* arr = malloc(range.length * sizeof(id));
	memcpy(arr, myArray + range.location, range.length * sizeof(id));
	return [[[JBArray alloc] initWithCArray: arr size: range.length] autorelease];
}

- (void) reverse {
	int last = mySize / 2;
	for (int i = 0; i < last; i++) {
		id tmp = myArray[i];
		myArray[i] = myArray[mySize - 1 - i];
		myArray[mySize - 1 - i] = tmp;
	}
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
	[self sort: cmp left: 0 right: mySize - 1];
}

@end

