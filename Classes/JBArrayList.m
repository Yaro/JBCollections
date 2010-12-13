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

- (id) initWithCapacity: (NSInteger) n {
	if (n < 0) @throw [NSException exceptionWithName: @"negative arraylist size" reason: @"" userInfo: nil];
	[super init];
	myData = arrayWithLength(n);
	myLength = n;
	mySize = 0;
	return self;
}

- (id) init {
	return [self initWithCapacity: 10];
}

- (id) initWithCollection: (id<JBCollection>) c {
	[super init];
	myData = [c toArray];
	mySize = [c size];
	myLength = mySize;
	for (int i = 0; i < mySize; i++)
		[myData[i] retain];
	return self;
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
	for (int i = 0; i < mySize; i++)
		if ([o isEqual: myData[i]])
			return i;
	return -1;		
}

- (id*) toArray {
	return copyOf(myData, mySize);
}

- (NSObject*) get: (NSInteger) i {
	[self rangeCheck: i];
	return myData[i];
}

- (id) setObject: (id) o atIndex: (NSInteger) i {
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

- (void) insert: (id) o atIndex: (NSInteger) index {
	[self rangeCheckForAdd: index];
	[self ensureCapacity: mySize + 1];
	for (int i = mySize - 1; i >= index; i--)
		myData[i + 1] = myData[i];
	myData[index] = [o retain];
	mySize++;
}

- (id) removeAt: (NSInteger) index {
	[self rangeCheck: index];
	id ret = myData[index];
	for (int i = index + 1; i < mySize; i++)
		myData[i - 1] = myData[i];
	mySize--;
	[ret release];
	return ret;
}

- (BOOL) remove: (id) o {
	for (int i = 0; i < mySize; i++)
		if ([o isEqual: myData[i]]) {
			[self removeAt: i];
			return TRUE;
		}
	return FALSE;
}


- (void) clear {
	for (int i = 0; i < mySize; i++) {
		[myData[i] release];
		myData[i] = nil;
	}
	mySize = 0;
}

- (void) dealloc {
	[self clear];
	free(myData);
	[super dealloc];
}

// JBAbstractList provides iterator for <RandomAccess> list implementations

/*- (id<JBIterator>) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= mySize) return nil;
		return myData[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	}] autorelease];
}*/


// JBAbstractCollection can be responsible for this operation

/*- (BOOL) addAll: (NSObject<JBCollection>*) c {
	id* arr = [c toArray];
	int arrLen = [c size];
	int nSize = mySize + arrLen;
	[self ensureCapacity: nSize];
	for (int i = mySize, j = 0; i < nSize; i++, j++)
		myData[i] = [arr[j] retain];
	mySize = nSize;
	deleteArray(arr);
	return arrLen != 0;
}*/


- (void) rangeCheck: (NSInteger) i {
	if (i < 0 || i >= mySize)
		@throw [NSException exceptionWithName: @"JBArrayList index out of bounds: " reason: [NSString stringWithFormat:@"Index = %d, Size = %d", i, mySize] userInfo: nil];
}

- (void) rangeCheckForAdd: (NSInteger) i {
	if (i < 0 || i > mySize)
		@throw [NSException exceptionWithName: @"JBArrayList index out of bounds: " reason: [NSString stringWithFormat:@"Index = %d, Size = %d", i, mySize] userInfo: nil];
}

@end