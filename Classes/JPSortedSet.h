#import <Foundation/Foundation.h>

@class JPRBNode;

@interface JPSortedSet : NSObject {
	NSComparator myComparator;
	JPRBNode* myRoot;
	int myCount;
}


- (id) initWithComparator: (NSComparator) comparator;

- (BOOL) add: (NSObject*) obj;
- (BOOL) remove: (NSObject*) obj;
- (BOOL) contains: (NSObject*) obj;
- (NSObject*) next: (NSObject*) obj;
- (NSObject*) prev: (NSObject*) obj;

- (NSObject*) first;
- (NSObject*) last;

- (NSArray*) toArray;

- (int) count;

@end

//internal
@interface JPRBNode : NSObject {
	BOOL myRed;
	NSObject* myValue;
	JPRBNode* myLeft;
	JPRBNode* myRight;
}

- (id) initWithValue: (NSObject*) value;

- (JPRBNode*) rotateLeft;
- (JPRBNode*) rotateRight;
- (void) colorFlip;
- (JPRBNode*) moveRedRight;
- (JPRBNode*) moveRedLeft;
- (JPRBNode*) fixUp;
- (JPRBNode*) min;
- (JPRBNode*) max;
- (JPRBNode*) deleteMin;

- (void) collectToArray: (NSMutableArray*) array;

@property (readwrite) BOOL red;
@property (readwrite, retain) NSObject* value;
@property (readwrite, retain) JPRBNode* left;
@property (readwrite, retain) JPRBNode* right;

@end