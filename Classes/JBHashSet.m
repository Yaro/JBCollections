#import "JBHashSet.h"

@implementation JBHashSet

/*
When we add object to the set the return value stands for this object presense in the set;
backing map in its turn returns the value of the JBMapEntry for the key if it is present in the map,
so we should distinguish nil return (when map doesn't contain such a key) and value return (when the value for the key is returned)
 Therefore, PRESENCE object is a sign of the map containing the key.
*/
static NSObject* PRESENCE;
extern double DEFAULT_LOAD_FACTOR;
extern int DEFAULT_INIT_CAPACITY;

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[JBHashMap alloc] initWithCapacity: initCapacity loadFactor: f];
	return self;
}

- (id) initWithCapacity: (NSInteger) initCapacity {
	return [self initWithCapacity: initCapacity loadFactor: DEFAULT_LOAD_FACTOR];
}

- (id) init {
	return [self initWithCapacity: DEFAULT_INIT_CAPACITY loadFactor: DEFAULT_LOAD_FACTOR];
}

- (NSObject<JBIterator>*) iterator {
	return [myMap keyIterator];
}

- (BOOL) isEqual: (id) o {
	if (!([o isMemberOfClass: [JBHashSet class]])) {
		return NO;
	}
	return [myMap isEqual: ((JBHashSet*)o)->myMap];
}


- (BOOL) remove: (id) o {
	return [myMap remove: o] != nil;
}

- (BOOL) contains: (id) o {
	return [myMap containsKey: o];
}

- (BOOL) add: (NSObject*) o {
	return [myMap putKey: o withValue: PRESENCE] == nil;
}

- (void) clear {
	[myMap clear];
}

- (NSUInteger) size {
	return [myMap size];
}

- (void) dealloc {
	[myMap release];
	[super dealloc];
}

@end

