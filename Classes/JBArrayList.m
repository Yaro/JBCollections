#import "JBArrayList.h"
#import "JBArrays.h"

@interface JBArrayList()

- (void) rangeCheck: (NSInteger) i;
- (void) rangeCheckForAdd: (NSInteger) i;
- (void) ensureCapacity: (NSInteger) minLength;
- (void) trimToSize;

@end

@implementation JBArrayList

@synthesize size = mySize;

+ (id) withCapacity: (NSInteger) n {
	return [[[JBArrayList alloc] initWithCapacity: n] autorelease];
}

- (id) initWithCapacity: (NSInteger) n {
	if (n <= 0) {
		@throw [NSException exceptionWithName: @"non-positive capacity" reason: @"" userInfo: nil];
	}
	[super init];
	myData = arrayWithLength(n);
	myLength = n;
	mySize = 0;
	return self;
}

+ (id) withCollection: (<JBCollection>) c {
	JBArrayList* ret = [JBArrayList withCapacity: MAX([c size], 10)];
	[ret addAll: c];
	return ret;
}

- (id) init {
	return [self initWithCapacity: 10];
}

- (void) trimToSize {
	id* newData = copyOf(myData, mySize);
	free(myData);
	myData = newData;
	myLength = mySize;
}

- (void) ensureCapacity: (NSInteger) minLength {
	if (minLength > myLength) {
		int nLength = MAX((myLength * 3) / 2 + 1, minLength);
		id* newData = arrayWithLength(nLength);
		memcpy(newData, myData, sizeof(id) * myLength);
		free(myData);
		myData = newData;
		myLength = nLength;
	}
}

- (int) indexOf: (NSObject*) o {
	for (int i = 0; i < mySize; i++) {
		if ([o isEqual: myData[i]]) {
			return i;
		}
	}
	return -1;		
}

- (id*) toArray {
	return copyOf(myData, mySize);
}

- (NSObject*) get: (NSInteger) i {
	[self rangeCheck: i];
	return myData[i];
}

- (id) set: (id) o at: (NSInteger) i {
	[self rangeCheck: i];
	id ret = myData[i];
	myData[i] = [o retain];
	[ret release];
	return ret;
}

- (BOOL) add: (NSObject*) o {
	[self ensureCapacity: mySize + 1];
	myData[mySize++] = [o retain];
	return TRUE;
}

- (void) insert: (id) o at: (NSInteger) index {
	[self rangeCheckForAdd: index];
	[self ensureCapacity: mySize + 1];
	for (int i = mySize - 1; i >= index; i--) {
		myData[i + 1] = myData[i];
	}
	myData[index] = [o retain];
	mySize++;
}

- (id) removeAt: (NSInteger) index {
	[self rangeCheck: index];
	id ret = myData[index];
	for (int i = index + 1; i < mySize; i++) {
		myData[i - 1] = myData[i];
	}
	mySize--;
	if (mySize >= 10 && myLength > (mySize * 5) / 2) {
		[self trimToSize];
	}
	return [ret autorelease];
}

- (BOOL) remove: (id) o {
	for (int i = 0; i < mySize; i++) {
		if ([o isEqual: myData[i]]) {
			[self removeAt: i];
			return TRUE;
		}
	}
	return FALSE;
}


- (void) clear {
	for (int i = 0; i < mySize; i++) {
		[myData[i] release];
		myData[i] = nil;
	}
	if (myLength > 30) {
		free(myData);
		myLength = 10;
		myData = arrayWithLength(10);
	}
	mySize = 0;
}

- (void) dealloc {
	[self clear];
	deleteArray(myData);
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

- (void) rangeCheck: (NSInteger) i {
	if (i < 0 || i >= mySize) {
		@throw [JBExceptions indexOutOfBounds: i size: mySize];
	}
}

- (void) rangeCheckForAdd: (NSInteger) i {
	if (i < 0 || i > mySize) {
		@throw [JBExceptions indexOutOfBounds: i size: mySize];
	}
}

@end