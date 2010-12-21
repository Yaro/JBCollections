#import "JBAbstractSortedSet.h"


@implementation JBAbstractSortedSet

NSObject* PRESENCE;

@dynamic comparator;

- (id) initWithComparator: (NSComparator) comp {
	@throw [NSException exceptionWithName: @"undefined method" reason: @"should be overriden by descendant class" userInfo: nil];
}

- (id) init {
	@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

- (id) initWithObjects: (id) firstObject, ... {
	@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

- (id) initWithCollection: (id<JBCollection>) c {
	SEL comparatorSelector = @selector(comparator);
	if ([(id)c respondsToSelector: comparatorSelector]) {
		return [self initWithSortedSet: c];
	} else {
		@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
	}
}

- (id) initSafe {
	return [super init];
}

- (id) initWithSortedSet: (id<JBCollection>) set {
	SEL comparatorSelector = @selector(comparator);
	[self initWithComparator: [(id)set performSelector: comparatorSelector]];
	[self addAll: set];
	return self;
}

- (NSComparator) comparator {
	return [myMap comparator];
}

- (id) first {
	return [myMap firstKey];
}

- (id) last {
	return [myMap lastKey];
}

- (id) next: (id) key {
	return [myMap nextKey: key];
}

- (id) prev: (id) key {
	return [myMap prevKey: key];
}

- (id) prevOrEqual: (id) key {
	return [myMap prevOrEqualKey: key];
}

- (id) nextOrEqual: (id) key {
	return [myMap nextOrEqualKey: key];
}

- (NSObject<JBIterator>*) iterator {
	return [myMap keyIterator];
}

- (BOOL) remove: (id) o {
	return [myMap remove: o] != nil;
}

- (NSUInteger) size {
	return [myMap size];
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

- (void) dealloc {
	[myMap release];
	[super dealloc];
}

@end
