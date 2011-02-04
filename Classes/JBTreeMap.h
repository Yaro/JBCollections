#import <Foundation/Foundation.h>
#import "JBAbstractMap.h"
#import "JBAbstractSortedMap.h"
#import "JBSortedMap.h"

@class RBNode;

@interface JBTreeMap : JBAbstractSortedMap<JBSortedMap> {
	RBNode* myRoot;
	NSUInteger mySize;
}

@property (readonly) NSUInteger size;


@end