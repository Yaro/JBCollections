#import "JBSet.h"
#import "JBAbstractCollection.h"
@class Entry;

@interface JBSplayTree : JBAbstractCollection<JBSet> {
	NSInteger mySize;
	NSComparator myComparator;
	Entry* myRoot;
}

- (Entry*) firstEntry;
- (Entry*) lastEntry;
- (Entry*) prevEntry: (Entry*) e;
- (Entry*) nextEntry: (Entry*) e;

@end


@interface Entry : NSObject {
	id myO;
	Entry* myLeft,* myRight,* myPar;
}

@property (readwrite, nonatomic, retain) id o;
@property (readwrite, nonatomic, assign) Entry* left,* right,* par;

- (NSInteger) toParent;
- (BOOL) hasRight;
- (BOOL) hasLeft;
- (void) unlinkParent;
- (id) initWithObject: (id) o;
- (void) splay;
- (void) splayOnce;
- (void) rotateWithParent;

@end
