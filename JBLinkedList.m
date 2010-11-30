#import "JBLinkedList.h"


@implementation JBLinkedList

- (void) addFirst: (id) o {
	[o retain];
	LREntry nEntry = MakeLREntry(o, myFirst, nil);
	myFirst = &nEntry;
	size++;
}

- (id) removeFirst {
	id ret = myFirst->myItem;
	LREntryPtr nFirst = myFirst->myNextItem;
	free(myFirst);
	myFirst = nFirst;
	[ret release];
	return ret;
}

/*- (void) addLast: (id) o;
- (id) getFirst;
- (id) getLast;
- (id) removeLast;
- (id) removeFirst;
*/


@end
