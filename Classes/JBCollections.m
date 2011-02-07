#import "JBCollections.h"
#import "JBArray.h"

inline BOOL equals(id o1, id o2) {
	return (o1 == nil && o2 == nil) || [o1 isEqual: o2];
}

@implementation JBCollections

+ (void) sort: (id<JBList>) c with: (NSComparator) cmp {
	JBArray* arr = [c toJBArray];
	[c clear];
	[arr sort: cmp];
	[c addAll: arr];
}

@end
