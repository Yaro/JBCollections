#import "JBIntArray.h"

#define rangeCheck(i) if (i < 0 || i >= mySize) @throw [JBExceptions indexOutOfBounds: i size: mySize];

static int randInt(int l, int r) {
	return (int)(rand() % (r - l + 1) + l);
}


@implementation JBIntArray

@synthesize size = mySize;

- (id) initWithSize: (NSInteger) n {
	[super init];
	mySize = n;
	myArray = calloc(n, sizeof(TYPE));
	return self;
}

- (id) init {
	@throw [JBExceptions unsupportedOperation];
}

+ (JBIntArray*) withSize: (NSInteger) n {
	JBIntArray* ret = [[JBIntArray alloc] initWithSize: n];
	return [ret autorelease];
}


- (TYPE) set: (TYPE) object at: (NSInteger) i {
	rangeCheck(i);
	TYPE ret = myArray[i];
	myArray[i] = object;
	return ret;
}

- (TYPE) get: (NSInteger) i {
	rangeCheck(i);
	return myArray[i];
}

- (BOOL) contains: (TYPE) o {
	for (int i = 0; i < mySize; i++) {
		if (o == myArray[i]) {
			return YES;
		}
	}
	return NO;
}

- (int) indexOf: (TYPE) o {
	for (int i = 0; i < mySize; i++) {
		if (o == myArray[i]) {
			return i;
		}
	}
	return NSNotFound;		
}

- (TYPE) removeAt: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (void) clear {
	memset(myArray, 0, mySize * sizeof(TYPE));
}

- (void) dealloc {
	[self clear];
	free(myArray);
	[super dealloc];
}

- (NSObject<JBIntIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBIntAbstractIterator alloc] initWithNextCL: ^TYPE(void) {
		if (cursor >= mySize) {
			@throw [JBIntAbstractIterator noSuchElement];
		}
		return myArray[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < mySize;
	} removeCL: ^void(void) {
		if (cursor > 0) {
			[self removeAt: cursor - 1];
		} else {
			@throw [JBIntAbstractIterator badRemove];
		}
	}] autorelease];
}

- (id) initWithCArray: (TYPE*) array size: (NSInteger) nsize {
	[super init];
	myArray = array;
	mySize = nsize;
	return self;
}

- (JBIntArray*) subarray: (NSRange) range {
	rangeCheck(range.location);
	rangeCheck(range.location + range.length - 1);
	TYPE* arr = malloc(range.length * sizeof(TYPE));
	memcpy(arr, myArray + range.location, range.length * sizeof(TYPE));
	return [[[JBIntArray alloc] initWithCArray: arr size: range.length] autorelease];
}

- (void) reverse {
	int last = mySize / 2;
	for (int i = 0; i < last; i++) {
		TYPE tmp = myArray[i];
		myArray[i] = myArray[mySize - 1 - i];
		myArray[mySize - 1 - i] = tmp;
	}
}


- (void) sortleft: (int) l right: (int) r {
	if (l >= r) return;
	int xi = randInt(l, r);
	TYPE x = myArray[xi], t;
	int bl = l, br = r, bm = l;
	while (bm <= br) {
		if (myArray[bm] < x) {
			t = myArray[bl], myArray[bl] = myArray[bm], myArray[bm] = t;
			bl++;
			bm++;
		} else if (myArray[bm] > x) {
			t = myArray[bm], myArray[bm] = myArray[br], myArray[br] = t;
			br--;
		} else {
			bm++;
		}
	}
	[self sortleft: l right: bl - 1];
	[self sortleft: bm right: r];
}

- (void) sort {
	[self sortleft: 0 right: mySize - 1];
}

@end

