#import "JBHashMap.h"


@interface HMapEntry : MapEntry {
@public
	HMapEntry* myNextEntry;
}

@property (readwrite, assign) HMapEntry* nextEntry;

@end

@implementation HMapEntry

@synthesize nextEntry = myNextEntry;

@end


@interface JBHashMap()

- (NSUInteger) hash: (NSUInteger) h;
- (NSUInteger) indexFor: (NSUInteger) h;
- (void) resize: (NSUInteger) newCapacity;

@end

@implementation JBHashMap

const int MAX_CAPACITY = 1 << 30, DEFAULT_INIT_CAPACITY = 16;
const double DEFAULT_LOAD_FACTOR = .75;

@synthesize size = mySize, loadFactor = myLoadFactor;

#if 0
- (void) averageBucket {
	double expectation = mySize * 1.0 / myLength;
	double ro = 0;
	for (int i = 0; i < myLength; i++) {
		HMapEntry* e = myTable[i];
		int cnt = 0;
		while (e != nil) {
			e = e.nextEntry;
			cnt++;
		}
		ro += (cnt - expectation) * (cnt - expectation);
	}
	ro /= myLength;
	ro = sqrt(ro);
	NSLog(@"standart deviation = %.10f", ro);
}
#endif

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) factor {
	[super init];
	initCapacity = MIN(initCapacity, MAX_CAPACITY);
	myLength = 1;
	while (myLength < initCapacity)
		myLength <<= 1;
	myTable = arrayWithLength(myLength);
	myLoadFactor = factor;
	myThreshold = (int)(myLength * myLoadFactor);
	return self;
}

- (id) initWithCapacity: (NSInteger) initCapacity {
	return [self initWithCapacity: initCapacity loadFactor: DEFAULT_LOAD_FACTOR];
}

- (id) init {
	return [self initWithCapacity: DEFAULT_INIT_CAPACITY loadFactor: DEFAULT_LOAD_FACTOR];
}

- (NSObject<JBIterator>*) keyIterator {
	__block NSInteger done = 0, index = 0;
	__block HMapEntry* e = myTable[0];
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		while (index < myLength) {
			if (e == nil) {
				e = myTable[++index];
			} 
			else {
				done++;
				id ret = e.key;
				e = e.nextEntry;
				return ret;
			}
		}
		return nil;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	}] autorelease];
}

- (NSObject<JBIterator>*) entryIterator {
	__block NSInteger done = 0, index = 0;
	__block HMapEntry* e = myTable[0];
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		while (index < myLength) {
			if (e == nil) {
				e = myTable[++index];
			} 
			else {
				done++;
				id ret = e;
				e = e.nextEntry;
				return ret;
			}
		}
		return nil;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	}] autorelease];
}

- (void) resize: (NSUInteger) newCapacity {
	static int resizings = 0;
	NSLog(@"resized: %d times", resizings++);
	
	if (newCapacity > MAX_CAPACITY) {
		newCapacity = MAX_CAPACITY;
		myThreshold = MAX_CAPACITY;
		return;
	}
	NSInteger oldLength = myLength;
	myLength = newCapacity;
	HMapEntry** nTable = arrayWithLength(myLength);
	for (int i = 0; i < oldLength; i++) {
		for (HMapEntry* e = myTable[i]; e != nil;) {
			HMapEntry* next = e->myNextEntry;
			NSInteger index = [self indexFor: [self hash: [e.key hash]]];
			e->myNextEntry = nTable[index];
			nTable[index] = e;
			e = next;
		}
	}
	
	deleteArray(myTable);
	myTable = nTable;
	myThreshold = (int)(myLength * myLoadFactor);
}

- (BOOL) containsKey: (id) key {
	NSInteger index = [self indexFor: [self hash: [key hash]]];
	for (HMapEntry* e = myTable[index]; e != nil; e = e.nextEntry)
		if ([e.key isEqual: key]) return TRUE;
	return FALSE;
}

- (id) putKey: (id) key withValue: (id) value {
	if (key == nil || value == nil) {
		@throw [NSException exceptionWithName: @"nil keys or values not allowed" reason: @"" userInfo: nil];
	}
	NSInteger index = [self indexFor: [self hash: [key hash]]];
	for (HMapEntry* e = myTable[index]; e != nil; e = e->myNextEntry) {
		if ([e->myKey isEqual: key]) {
			id oldVal = [e->myValue retain];
			e.value = value;
			return [oldVal autorelease];
		}
	}
	HMapEntry* e = myTable[index];
	myTable[index] = [[HMapEntry alloc] initWithKey: key value: value];
	myTable[index]->myNextEntry = e;
	mySize++;
	if (mySize > myThreshold) {
		[self resize: 2 * myLength];
	}
	return nil;
}

- (id) get: (id) key {
	NSInteger index = [self indexFor: [self hash: [key hash]]];
	for (HMapEntry* e = myTable[index]; e != nil; e = e.nextEntry)
		if ([e.key isEqual: key]) return e.value;
	return nil;
}

- (id) remove: (id) key {
	NSInteger index = [self indexFor: [self hash: [key hash]]];
	HMapEntry* e = myTable[index],* prevEntry = e;
	while (e != nil) {
		if ([e.key isEqual: key]) {
			mySize--;
			if (e == prevEntry) {
				myTable[index] = e.nextEntry;
			} else {
				prevEntry.nextEntry = e.nextEntry;
			}
			id oldVal = e.value;
			[oldVal retain];
			[e release];
			return [oldVal autorelease];
		}
		prevEntry = e;
		e = e.nextEntry;
	}
	return nil;
}

- (void) releaseEntryList: (HMapEntry*) e {
	if (e == nil) return;
	[self releaseEntryList: e.nextEntry];
	[e release];
}

- (void) clear {
	for (int i = 0; i < myLength; i++) {
		[self releaseEntryList: myTable[i]];
		myTable[i] = nil;
	}
	mySize = 0;
}

- (void) dealloc {
	[self clear];
	deleteArray(myTable);
	[super dealloc];
}

- (NSUInteger) hash: (NSUInteger) h {
	h ^= (h >> 17) ^ (h >> 4) ^ (h << 19);
	return h;
}

- (NSUInteger) indexFor: (NSUInteger) h {
	return h & (myLength - 1);
}

@end
