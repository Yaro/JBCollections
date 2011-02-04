#import <Foundation/Foundation.h>
#import "JBSet.h"
#import "JBComparatorRequired.h"

@protocol JBSortedSet<JBSet, JBComparatorRequired>

- (id) init;
- (id) initWithComparator: (NSComparator) comp;
- (id) first;
- (id) last;
- (id) next: (id) key;
- (id) prev: (id) key;
- (id) prevOrEqual: (id) key;
- (id) nextOrEqual: (id) key;
- (NSComparator) comparator;

+ (id) withComparator: (NSComparator) comp;

@end
