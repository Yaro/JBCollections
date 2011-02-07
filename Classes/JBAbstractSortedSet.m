#import "JBAbstractSortedSet.h"
#import "JBCollections.h"



@implementation JBAbstractSortedSet

- (id) initWithComparator: (NSComparator) comp {
	@throw [NSException exceptionWithName: NSInternalInconsistencyException
						reason: [NSString stringWithFormat: @"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
						userInfo: nil];
}

- (id) init {
	@throw [JBExceptions needComparator];
}

+ (id) withCollection: (id<JBCollection>) c {
	if (![(id)c conformsToProtocol: @protocol(JBComparatorRequired)]) {
		@throw [JBExceptions needComparator];
	}
	id ret = [self withComparator: [(<JBComparatorRequired>)c comparator]];
	[ret addAll: c];
	return ret;
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
		if (!q1 || !q2 || !equals([iter next], [ourIter next])) {
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

- (BOOL) add: (id) o {
	return [myMap putKey: o withValue: [NSNull null]] == nil;
}

- (void) clear {
	[myMap clear];
}

- (void) dealloc {
	[myMap release];
	[super dealloc];
}

@end
