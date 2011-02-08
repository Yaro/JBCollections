#import "JBSplayTreeSet.h"


@implementation JBSplayTreeSet


- (id) initWithComparator: (NSComparator) comp {
	myMap = [[JBSplayTreeMap alloc] initWithComparator: comp];
	return self;
}

@end