#import <Foundation/Foundation.h>
#import "JBMap.h"
#import "JBComparatorRequired.h"

@protocol JBSortedMap<JBMap, JBComparatorRequired>

- (id) init;
- (id) initWithComparator: (NSComparator) comp;
- (id) firstKey;
- (id) lastKey;
- (id) nextKey: (id) key;
- (id) prevKey: (id) key;
- (id) nextOrEqualKey: (id) key;
- (id) prevOrEqualKey: (id) key;
- (NSComparator) comparator;

+ (id) withComparator: (NSComparator) comparator;

@end
