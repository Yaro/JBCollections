#import "JBAbstractSortedSet.h"


@implementation JBAbstractSortedSet

NSObject* PRESENCE;

@dynamic comparator;


- (id) initSafe {
	return [super init];
}

- (id) initWithComparator: (NSComparator) comp {
	@throw [NSException exceptionWithName: @"undefined method" reason: @"should be overriden by descendant class" userInfo: nil];
}

- (id) init {
	@throw [JBExceptions needComparator];
}


- (id) initWithSortedSet: (id<JBCollection>) set {
	SEL comparatorSelector = @selector(comparator);
	[self initWithComparator: [(id)set performSelector: comparatorSelector]];
	[self addAll: set];
	return self;
}

+ (id) withObjects: (id) firstObject, ... {
	@throw [JBExceptions needComparator];
}

+ (id) withCollection: (id<JBCollection>) c {
	SEL comparatorSelector = @selector(comparator);
	if ([(id)c respondsToSelector: comparatorSelector]) {
		return [[[self alloc] initWithSortedSet: c] autorelease];
	} else {
		@throw [JBExceptions needComparator];
	}
}

+ (id) withComparator: (NSComparator) comp {
	return [[[self alloc] initWithComparator: comp] autorelease];
}



- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractSortedSet class]])) {
		return NO;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || ![[ourIter next] isEqual: [iter next]]) {
			return NO;
		}
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return YES;
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
	return myMap.size;
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
