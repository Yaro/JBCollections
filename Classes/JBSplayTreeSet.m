#import "JBSplayTreeSet.h"
#import "JBArrays.h"



@implementation JBSplayTreeSet

extern NSObject* PRESENCE;

- (id) initWithComparator: (NSComparator) comp {
	[super init];
	if (PRESENCE == nil) {
		PRESENCE = [NSObject new];
	}
	myMap = [[JBSplayTreeMap alloc] initWithComparator: comp];
	return self;
}

@end