#import <UIKit/UIKit.h>
#import "JBMap.h"

@protocol JBSortedMap<JBMap>

- (id) init;
- (id) initWithComparator: (NSComparator) comp;
- (id) initWithSortedMap: (id) map;
- (id) firstKey;
- (id) lastKey;
- (id) nextKey: (id) key;
- (id) prevKey: (id) key;
- (id) nextOrEqualKey: (id) key;
- (id) prevOrEqualKey: (id) key;
- (NSComparator) comparator;

+ (id) withComparator: (NSComparator) comparator;

@end
