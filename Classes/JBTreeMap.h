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


@interface RBNode : MapEntry {
	BOOL myRed;
	RBNode* myLeft;
	RBNode* myRight;
}

- (RBNode*) rotateLeft;
- (RBNode*) rotateRight;
- (void) colorFlip;
- (RBNode*) moveRedRight;
- (RBNode*) moveRedLeft;
- (RBNode*) fixUp;
- (RBNode*) min;
- (RBNode*) max;
- (RBNode*) deleteMin;

@property (readwrite) BOOL red;
@property (readwrite, assign) RBNode* left;
@property (readwrite, assign) RBNode* right;

@end