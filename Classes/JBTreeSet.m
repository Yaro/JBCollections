#import "JBTreeSet.h"
#import "JBTreeMap.h"


@implementation JBTreeSet

- (id) initWithComparator: (NSComparator) comp {
	myMap = [[JBTreeMap alloc] initWithComparator: comp];
	return self;
}

@end