#import <Foundation/Foundation.h>
#import "JBAbstractMap.h"
#import "JBComparatorRequired.h"

@interface JBAbstractSortedMap : JBAbstractMap {
	NSComparator myComparator;
}

@property (readonly) NSComparator comparator;

+ (id) withComparator: (NSComparator) comparator;
+ (id) withKeysAndObjects: (id) firstKey, ...;
+ (id) withMap: (id<JBMap>) map;

- (id) initWithComparator: (NSComparator) cmp;

- (BOOL) isEqual: (id) o;

@end
