#import "JBHashMap.h"


@interface HMapEntry : JBMapEntry {
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

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) factor {
	[super init];
	initCapacity = MIN(initCapacity, MAX_CAPACITY);
	myLength = 1;
	while (myLength < initCapacity) {
		myLength <<= 1;
	}
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
	__block HMapEntry* e = myTable[0],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		while (index < myLength) {
			if (e == nil) {
				e = myTable[++index];
			} 
			else {
				done++;
				prev = e;
				e = e.nextEntry;
				return prev.key;
			}
		}
		@throw [JBAbstractIterator noSuchElement];
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];
		done--;
	}] autorelease];
}

- (NSObject<JBIterator>*) entryIterator {
	__block NSInteger done = 0, index = 0;
	__block HMapEntry* e = myTable[0],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		while (index < myLength) {
			if (e == nil) {
				e = myTable[++index];
			} 
			else {
				done++;
				prev = e;
				e = e.nextEntry;
				return prev;
			}
		}
		@throw [JBAbstractIterator noSuchElement];
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];
		done--;
	}] autorelease];
}

- (void) resize: (NSUInteger) newCapacity {
	if (newCapacity > MAX_CAPACITY) {
		newCapacity = MAX_CAPACITY;
		myThreshold = MAX_CAPACITY;
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
	for (HMapEntry* e = myTable[index]; e != nil; e = e.nextEntry) {
		if ([e.key isEqual: key]) {
			return YES;
		}
	}
	return NO;
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
	for (HMapEntry* e = myTable[index]; e != nil; e = e.nextEntry) {
		if ([e.key isEqual: key]) {
			return e.value;
		}
	}
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

- (BOOL) isEqual: (id) o {
	if (!([o isMemberOfClass: [JBHashMap class]])) {
		return NO;
	}
	JBHashMap* omap = (JBHashMap*)o;
	if (mySize != [omap size]) {
		return NO;
	}
	id iter = [omap entryIterator];
	for (int i = 0; i < mySize; i++) {
		HMapEntry* e = [iter next];
		if ([self get: e->myKey] != e->myValue) {
			return NO;
		}
	}
	return YES;
}

- (NSUInteger) hash: (NSUInteger) h {
	h ^= (h >> 17) ^ (h >> 4) ^ (h << 19);
	return h;
}

- (NSUInteger) indexFor: (NSUInteger) h {
	return h & (myLength - 1);
}

@end
