#import "JBTreeSet.h"
#import "JBTreeMap.h"

@implementation JBTreeSet

extern NSObject* PRESENCE;

- (id) initWithComparator: (NSComparator) comp {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[JBTreeMap alloc] initWithComparator: comp];
	return self;
}

@end
