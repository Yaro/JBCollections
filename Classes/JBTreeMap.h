#import <Foundation/Foundation.h>
#import "JBAbstractMap.h"
#import "JBSortedMap.h"

@class RBNode;

@interface JBTreeMap : JBAbstractMap<JBSortedMap> {
	@public
	NSComparator myComparator;
	RBNode* myRoot;
	NSUInteger mySize;
}

@property (readonly) NSUInteger size;
@property (readonly) NSComparator comparator;

@end