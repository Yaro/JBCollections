#import "JBHashSet.h"

@implementation JBHashSet

extern double DEFAULT_LOAD_FACTOR;
extern int DEFAULT_INIT_CAPACITY;

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f {
	[super init];
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

- (BOOL) add: (id) o {
	return [myMap putKey: o withValue: [NSNull null]] == nil;
}

- (void) clear {
	[myMap clear];
}

- (NSUInteger) size {
	return myMap.size;
}

- (void) dealloc {
	[myMap release];
	[super dealloc];
}

@end

