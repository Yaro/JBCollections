#import "JBArrayList.h"
#import "JBCollections.h"

#define rangeCheck(i) if (i < 0 || i >= mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];
#define rangeCheckForAdd(i) if (i < 0 || i > mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];

@interface JBArrayList()

- (void) grow: (NSInteger) len;
- (void) trimToSize;
- (id) initWithCArray: (id*) arr size: (NSInteger) n;

@end



@implementation JBArrayList

@synthesize size = mySize;

+ (id) withCapacity: (NSInteger) n {
	return [[[JBArrayList alloc] initWithCapacity: n] autorelease];
}

- (id) initWithCapacity: (NSInteger) n {
	if (n <= 0) {
		@throw [JBExceptions invalidArgument: [NSNumber	numberWithInt: n]];
	}
	myData = calloc(n, sizeof(id));
	myLength = n;
	mySize = 0;
	return self;
}

+ (id) withCollection: (<JBCollection>) c {
	JBArrayList* ret = [JBArrayList withCapacity: MAX(c.size, 10)];
	[ret addAll: c];
	return ret;
}

- (id) init {
	return [self initWithCapacity: 10];
}

- (void) trimToSize {
	myData = realloc(myData, mySize * sizeof(id));
	myLength = mySize;
}

- (void) grow: (NSInteger) len {
	int nLength = MAX((myLength * 3) / 2 + 1, len);
	myData = realloc(myData, nLength * sizeof(id));
	myLength = nLength;
}

- (int) indexOf: (id) o {
	for (int i = 0; i < mySize; i++) {
		if (equals(o, myData[i])) {
			return i;
		}
	}
	return NSNotFound;		
}

- (id) initWithCArray: (id*) arr size: (NSInteger) n {
	[super init];
	myData = arr;
	mySize = n;
	myLength = mySize;
	for (int i = 0; i < mySize; i++) {
		[arr[i] retain];
	}
	return self;
}

- (JBArrayList*) subarray: (NSRange) range {
	rangeCheck(range.location);
	rangeCheck(range.location + range.length - 1);
	id* arr = malloc(range.length * sizeof(id));
	memcpy(arr, myData + range.location, range.length * sizeof(id));
	return [[[JBArrayList alloc] initWithCArray: arr size: range.length] autorelease];
}

- (id) get: (NSInteger) i {
	rangeCheck(i);
	return myData[i];
}

- (id) set: (id) o at: (NSInteger) i {
	rangeCheck(i);
	id ret = myData[i];
	myData[i] = [o retain];
	return [ret autorelease];
}

- (BOOL) add: (id) o {
	if (mySize + 1 > myLength) {
		[self grow: mySize + 1];
	}
	myData[mySize++] = [o retain];
	return YES;
}

- (void) insert: (id) o at: (NSInteger) index {
	rangeCheckForAdd(index);
	if (mySize + 1 > myLength) {
		[self grow: mySize + 1];
	}
	for (int i = mySize - 1; i >= index; i--) {
		myData[i + 1] = myData[i];
	}
	myData[index] = [o retain];
	mySize++;
}

- (void) safeRemoveAt: (NSInteger) index {
	for (int i = index + 1; i < mySize; i++) {
		myData[i - 1] = myData[i];
	}
	mySize--;
	if (mySize >= 10 && myLength > (mySize * 5) / 2) {
		[self trimToSize];
	}
}

- (id) removeAt: (NSInteger) index {
	rangeCheck(index);
	id ret = myData[index];
	[self safeRemoveAt: index];
	return [ret autorelease];
}

- (BOOL) remove: (id) o {
	for (int i = mySize - 1; i >= 0; i--) {
		if (equals(o, myData[i])) {
			[self safeRemoveAt: i];
			return YES;
		}
	}
	return NO;
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	if (state->state == 0) {
		state->mutationsPtr = &(state->extra[0]);
		state->itemsPtr = myData;
		state->state = 1;
		return mySize;
	} else return 0;
}

- (void) clear {
	for (int i = 0; i < mySize; i++) {
		[myData[i] release];
		myData[i] = nil;
	}
	if (myLength > 30) {
		myLength = 10;
		myData = realloc(myData, myLength * sizeof(id));
	}
	mySize = 0;
}

- (void) dealloc {
	for (int i = 0; i < mySize; i++) {
		[myData[i] release];
	}
	free(myData);
	[super dealloc];
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= mySize) {
			@throw [JBAbstractIterator noSuchElement];
		}
		return myData[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	} removeCL: ^void(void) {
		if (cursor > 0) {
			[self removeAt: --cursor];
		} else {
			@throw [JBAbstractIterator badRemove];
		}
	}] autorelease];
}

@end