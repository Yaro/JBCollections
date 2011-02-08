#import "JBIntArrayList.h"
#import "JBCollection.h"

#define rangeCheck(i) if (i < 0 || i >= mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];
#define rangeCheckForAdd(i) if (i < 0 || i > mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];

@interface JBIntArrayList()

- (void) grow: (NSInteger) len;
- (void) trimToSize;
- (id) initWithCArray: (TYPE*) arr size: (NSInteger) n;

@end



@implementation JBIntArrayList

@synthesize size = mySize;

+ (id) withCapacity: (NSInteger) n {
	return [[[JBIntArrayList alloc] initWithCapacity: n] autorelease];
}

- (id) initWithCapacity: (NSInteger) n {
	if (n <= 0) {
		@throw [JBExceptions invalidArgument: [NSNumber	numberWithInt: n]];
	}
	myData = calloc(n, sizeof(TYPE));
	myLength = n;
	mySize = 0;
	return self;
}

+ (id) withCollection: (<JBIntCollection>) c {
	JBIntArrayList* ret = [JBIntArrayList withCapacity: MAX(c.size, 10)];
	[ret addAll: c];
	return ret;
}

- (id) init {
	return [self initWithCapacity: 10];
}

- (void) trimToSize {
	myData = realloc(myData, mySize * sizeof(TYPE));
	myLength = mySize;
}

- (void) grow: (NSInteger) len {
	int nLength = MAX((myLength * 3) / 2 + 1, len);
	myData = realloc(myData, nLength * sizeof(TYPE));
	myLength = nLength;
}

- (NSInteger) indexOf: (TYPE) o {
	for (int i = 0; i < mySize; i++) {
		if (myData[i] == o) {
			return i;
		}
	}
	return NSNotFound;		
}

- (id) initWithCArray: (TYPE*) arr size: (NSInteger) n {
	[super init];
	myData = arr;
	mySize = n;
	myLength = mySize;
	return self;
}

- (JBIntArrayList*) subarray: (NSRange) range {
	rangeCheck(range.location);
	rangeCheck(range.location + range.length - 1);
	TYPE* arr = malloc(range.length * sizeof(TYPE));
	memcpy(arr, myData + range.location, range.length * sizeof(TYPE));
	return [[[JBIntArrayList alloc] initWithCArray: arr size: range.length] autorelease];
}

- (TYPE) get: (NSInteger) i {
	rangeCheck(i);
	return myData[i];
}

- (TYPE) set: (TYPE) o at: (NSInteger) i {
	rangeCheck(i);
	TYPE ret = myData[i];
	return ret;
}

- (BOOL) add: (TYPE) o {
	if (mySize + 1 > myLength) {
		[self grow: mySize + 1];
	}
	myData[mySize++] = o;
	return YES;
}

- (void) insert: (TYPE) o at: (NSInteger) index {
	rangeCheckForAdd(index);
	if (mySize + 1 > myLength) {
		[self grow: mySize + 1];
	}
	for (int i = mySize - 1; i >= index; i--) {
		myData[i + 1] = myData[i];
	}
	myData[index] = o;
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

- (TYPE) removeAt: (NSInteger) index {
	rangeCheck(index);
	TYPE ret = myData[index];
	[self safeRemoveAt: index];
	return ret;
}

- (BOOL) remove: (TYPE) o {
	for (int i = mySize - 1; i >= 0; i--) {
		if (o == myData[i]) {
			[self safeRemoveAt: i];
			return YES;
		}
	}
	return NO;
}


- (void) clear {
	memset(myData, 0, mySize * sizeof(TYPE));
	if (myLength > 30) {
		myLength = 10;
		myData = realloc(myData, myLength * sizeof(TYPE));
	}
	mySize = 0;
}

- (void) dealloc {
	free(myData);
	[super dealloc];
}

- (NSObject<JBIntIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBIntAbstractIterator alloc] initWithNextCL: ^TYPE(void) {
		if (cursor >= mySize) {
			@throw [JBIntAbstractIterator noSuchElement];
		}
		return myData[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	} removeCL: ^void(void) {
		if (cursor > 0) {
			[self removeAt: --cursor];
		} else {
			@throw [JBIntAbstractIterator badRemove];
		}
	}] autorelease];
}

@end