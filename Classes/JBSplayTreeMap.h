#import <Foundation/Foundation.h>
#import "JBAbstractMap.h"
#import "JBSortedMap.h"
@class TMapEntry;

@interface JBSplayTreeMap : JBAbstractMap<JBSortedMap> {
@public
	NSComparator myComparator;
	NSUInteger mySize;
	TMapEntry* myRoot;
}

@property (readonly) NSComparator comparator;
@property (readonly, assign) NSUInteger size;

@end