#import "JBAbstractList.h"
#import "JBDeque.h"

@interface JBLinkedList : JBAbstractList <JBDeque>  {
	LREntryPtr myFirst, myLast;
	int size;
}



@end