#import "JBLinkedList.h"

@interface JBLinkedList()

- (LRNode*) node: (NSUInteger) index;
- (id) unlinkNode: (LRNode*) node;

@end

@implementation JBLinkedList

@synthesize size = mySize;

inline static void rangeCheck(JBLinkedList* list, NSInteger i) {
	if (i < 0 || i >= list.size)
		@throw [NSException exceptionWithName:@"JBLinkedList index out of bounds" 
									   reason:[NSString stringWithFormat:@"Index: %d Size: %d", i, list.size] userInfo:nil];
}


- (LRNode*) node: (NSUInteger) index {
	rangeCheck(self, index);
	if (index > (mySize >> 1)) {
		LRNode* x = myLast;
		for (int i = mySize - 1; i > index; i--)
			x = x->myPrevNode;
		return x;
	} else {
		LRNode* x = myFirst;
		for (int i = 0; i < index; i++)
			x = x->myNextNode;
		return x;
	}
}

- (id) unlinkNode: (LRNode*) node {
	id ret = node->myItem;
	if (node == myFirst) {
		myFirst = myFirst->myNextNode;
	} else {
		node->myPrevNode->myNextNode = node->myNextNode;
	}
	if (node == myLast) {
		myLast = myLast->myPrevNode;
	} else {
		node->myNextNode->myPrevNode = node->myPrevNode;
	}
	mySize--;
	//NSLog(@"%d", node);
	[node release];
	[ret autorelease];
	return ret;
}


- (id) initWithCollection: (<JBCollection>) c {
	[self init];
	[self addAll:c];
	return self;
}

- (void) addFirst: (id) o {
	[o retain];
	if (myFirst == nil) {
		myFirst = myLast = [[LRNode createNodeWithPrev:nil next:nil item:o] retain];
	} else {
		LRNode* nNode = [[LRNode createNodeWithPrev:myFirst next:nil item:o] retain];
		myFirst->myPrevNode = nNode;
		myFirst = nNode;
	}
	mySize++;
}

- (void) addLast: (id) o {
	[o retain];
	if (myLast == nil) {
		myFirst = myLast = [[LRNode createNodeWithPrev:nil next:nil item:o] retain];
		//NSLog(@"%d", myFirst);
	} else {
		LRNode* nNode = [[LRNode createNodeWithPrev:myLast next:nil item:o] retain];
		myLast->myNextNode = nNode;
		myLast = nNode;
		//NSLog(@"%d", nNode);
	}
	mySize++;
}

- (id) removeFirst {
	if (myFirst == nil) return nil;
	id ret = myFirst->myItem;
	[self unlinkNode:myFirst];
	/*LRNode* nFirst = myFirst->myNextNode;
	[myFirst release];
	myFirst = nFirst;
	[ret release];*/
	return ret;
}

- (id) removeLast {
	if (myLast == nil) return nil;
	id ret = myLast->myItem;
	[self unlinkNode:myLast];
	/*LRNode* nLast = myLast->myPrevNode;
	[myLast release];
	myLast = nLast;
	[ret release];*/
	return ret;
}



- (id) getFirst {
	return myFirst->myItem;
}

- (id) getLast {
	return myLast->myItem;
}

- (BOOL) add: (id) o {
	[self addLast:o];
	return TRUE;
}


- (void) clear {
	while (mySize > 0) {
		[self removeFirst];
	}
}

- (id) get: (NSInteger) index {
	return [self node:index]->myItem;
}

- (NSInteger) indexOf: (id) o {
	LRNode* x = myFirst;
	for (int i = 0; i < mySize; i++) {
		if ([x->myItem isEqual: o]) return i;
		x = x->myNextNode;
	}
	return -1;
}

- (BOOL) contains: (id) o {
	return [self indexOf:o] != -1;
}

- (BOOL) remove: (id) o {
	LRNode* x = myFirst;
	for (int i = 0; i < mySize; i++) {
		if ([x->myItem isEqual: o]) {
			[self unlinkNode:x];
			return TRUE;
		}
	}
	return FALSE;
}

- (id) setObject: (id) o atIndex: (NSInteger) index {
	rangeCheck(self, index);
	LRNode* x = [self node:index];
	id ret = x->myItem;
	x->myItem = o;
	return ret;
}


- (BOOL) addAll: (id <JBCollection>) c {
	JBArray* cArr = [[c toArray] retain];
	for (int i = 0; i < cArr.length; i++) {
		[self addLast: [cArr get: i]];
	}
	[cArr release];
	return TRUE;
}

- (NSUInteger) hash {
	LRNode* x = myFirst;
	NSUInteger ret = 0;
	for (int i = 0; i < mySize; i++) {
		ret ^= [x->myItem hash];
		x = x->myNextNode;
	}
	return ret;
}

- (NSString*) toString {
	return [NSString stringWithFormat: @"JBLinkedList instance, size = %d", mySize];
}

   /*- (id <JBList>) subListInRange: (NSRange) range;
- (BOOL) containsAll: (id <JBCollection>) c;
- (BOOL) isEqual: (id) o;
- (BOOL) removeAll: (id <JBCollection>) c;*/

@end
