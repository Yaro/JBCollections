#import "JBAbstractList.h"
#import "JBDeque.h"

@interface JBLinkedList : JBAbstractList <JBDeque>  {
	LRNode* myFirst;
	LRNode* myLast;
	NSInteger mySize;
}

@property (readonly, assign, nonatomic) NSInteger size;

- (id) initWithCollection: (<JBCollection>) c;

@end