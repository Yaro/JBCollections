#import <UIKit/UIKit.h>
#import "JBSet.h"

@protocol JBSortedSet<JBSet>

- (id) init;
- (id) initWithComparator: (NSComparator) comp;
- (id) initWithSortedSet: (id<JBCollection>) set;
- (id) first;
- (id) last;
- (id) next: (id) key;
- (id) prev: (id) key;
- (id) prevOrEqual: (id) key;
- (id) nextOrEqual: (id) key;

+ (id) withComparator: (NSComparator) comp;

@end
