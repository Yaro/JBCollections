#import "JBAbstractList.h"
#import "JBDeque.h"
@class LRNode;

@interface JBLinkedList : JBAbstractList<JBDeque>  {
	LRNode* myFirst;
	LRNode* myLast;
	NSInteger mySize;
}

@property (readonly, assign, nonatomic) NSInteger size;

@end