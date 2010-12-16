#import "JBHashSet.h"

@implementation JBHashSet

/*
When we add object to the set the return value stands for this object presense in the set
backing map in its turn returns the value of the MapEntry for the key if it is present in the map,
so we should distinguish nil return (when map doesn't contain such a key) and value return (when the value for the key is returned)
 Therefore, PRESENCE object is a sign of the map containing the key.
*/
static NSObject* PRESENCE;

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[JBHashMap alloc] initWithCapacity: initCapacity loadFactor: f];
	return self;
}

- (id) initWithCapacity: (NSInteger) initCapacity {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[JBHashMap alloc] initWithCapacity: initCapacity];
	return self;
}

- (id) init {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [JBHashMap new];
	return self;
}

- (NSObject<JBIterator>*) iterator {
	return [myMap keyIterator];
}

- (BOOL) remove: (id) o {
	return [myMap remove: o] != nil;
}

- (BOOL) contains: (id) o {
	return [myMap containsKey: o];
}

- (BOOL) add: (NSObject*) o {
	return [myMap putKey: o withValue: PRESENCE] != nil;
}

- (void) clear {
	[myMap clear];
}

- (NSUInteger) size {
	return [myMap size];
}

- (void) dealloc {
	NSLog(@"%d", [myMap retainCount]);
	[myMap release];
	[super dealloc];
}

@end

