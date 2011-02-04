#import "JBAbstractSortedMap.h"


@implementation JBAbstractSortedMap

@synthesize comparator = myComparator;

- (id) initWithComparator: (NSComparator) cmp {
	[super init];
	myComparator = [cmp copy];
	return self;
}

+ (id) withComparator: (NSComparator) comparator {
	return [[[self alloc] initWithComparator: comparator] autorelease];
}

- (id) init {
	@throw [JBExceptions needComparator];
}

+ (id) withKeysAndObjects: (id) firstKey, ... {
	@throw [JBExceptions needComparator];
}

+ (id) withMap: (id<JBMap>) map {
	if (![(id)map conformsToProtocol: @protocol(JBComparatorRequired)]) {
		@throw [JBExceptions needComparator];
	}
	id ret = [self withComparator: [(<JBComparatorRequired>)map comparator]];
	[ret putAll: map];
	return ret;
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractSortedMap class]])) {
		return NO;
	}
	id ourIter = [self entryIterator], iter = [o entryIterator];
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


@end
