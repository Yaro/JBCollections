#import "JBAbstractSortedSet.h"


@implementation JBAbstractSortedSet

NSObject* PRESENCE;

@dynamic comparator;

//if it works

- (id) initWithComparator: (NSComparator) comp {
	[super performSelector: @selector(initSafe)];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[[myMap class] alloc] initWithComparator: comp];
	return self;
}

/*- (id) initWithComparator: (NSComparator) comp {
	@throw [NSException exceptionWithName: @"undefined method" reason: @"should be overriden by descendant class" userInfo: nil];
}*/

- (id) init {
	@throw [JBExceptions needComparator];
}

- (id) initWithObjects: (id) firstObject, ... {
	@throw [JBExceptions needComparator];
}

- (id) initWithCollection: (id<JBCollection>) c {
	SEL comparatorSelector = @selector(comparator);
	if ([(id)c respondsToSelector: comparatorSelector]) {
		return [self initWithSortedSet: c];
	} else {
		@throw [JBExceptions needComparator];
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

- (id) withComparator: (NSComparator) comp {
	return [[[[self class] alloc] initWithComparator: comp] autorelease];
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractSortedSet class]])) {
		return FALSE;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || ![[ourIter next] isEqual: [iter next]]) {
			return FALSE;
		}
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return TRUE;
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
