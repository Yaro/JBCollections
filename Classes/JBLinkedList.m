#import "JBLinkedList.h"
#import "JBArrayList.h"
#import "JBCollections.h"

@interface LRNode : NSObject {
@public
	LRNode* myNextNode;
	LRNode* myPrevNode;
	id myItem;
}

@property (readwrite, nonatomic, assign) LRNode* nextNode;
@property (readwrite, nonatomic, assign) LRNode* prevNode;
@property (readwrite, nonatomic, assign) id item;

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item;

@end


@interface JBLinkedList()

- (LRNode*) node: (NSInteger) index;
- (id) unlinkNode: (LRNode*) node;

@end

@implementation JBLinkedList

@synthesize size = mySize;

inline static void rangeCheck(JBLinkedList* list, NSInteger i) {
	if (i < 0 || i >= list.size) {
		@throw [JBExceptions indexOutOfBounds: i size: list.size];
	}
}


- (LRNode*) node: (NSInteger) index {
	rangeCheck(self, index);
	if (index > (mySize >> 1)) {
		LRNode* x = myLast;
		for (int i = mySize - 1; i > index; i--) {
			x = x.prevNode;
		}
		return x;
	} else {
		LRNode* x = myFirst;
		for (int i = 0; i < index; i++) {
			x = x.nextNode;
		}
		return x;
	}
}

- (id) unlinkNode: (LRNode*) node {
	id ret = node.item;
	
	if (node == myFirst) {
		myFirst = myFirst.nextNode;
	} else {
		node.prevNode.nextNode = node.nextNode;
	}
	
	if (node == myLast) {
		myLast = myLast.prevNode;
	} else {
		node.nextNode.prevNode = node.prevNode;
	}
	
	mySize--;
	
	[node release];
	return [ret autorelease];
}

- (void) addFirst: (id) o {
	[o retain];
	if (myFirst == nil) {
		myFirst = myLast = [[LRNode createNodeWithPrev: nil next: nil item: o] retain];
	} else {
		LRNode* nNode = [[LRNode createNodeWithPrev: nil next: myFirst item: o] retain];
		myFirst.prevNode = nNode;
		myFirst = nNode;
	}
	mySize++;
}

- (void) addLast: (id) o {
	[o retain];
	if (myLast == nil) {
		myFirst = myLast = [[LRNode createNodeWithPrev: nil next: nil item: o] retain];
	} else {
		LRNode* nNode = [[LRNode createNodeWithPrev: myLast next: nil item: o] retain];
		myLast->myNextNode = nNode;
		myLast = nNode;
	}
	mySize++;
}

- (id) removeFirst {
	return self.isEmpty ? nil : [self unlinkNode: myFirst];
}

- (id) removeLast {
	return self.isEmpty ? nil : [self unlinkNode: myLast];
}

- (id) removeAt: (NSInteger) index {
	return [self unlinkNode: [self node: index]];
}

- (id) first {
	return self.isEmpty ? nil : myFirst.item;
}

- (id) last {
	return self.isEmpty ? nil : myLast.item;
}

- (BOOL) add: (id) o {
	[self addLast: o];
	return YES;
}


- (void) clear {
	while (mySize > 0) {
		[self removeFirst];
	}
}

- (void) dealloc {
	[self clear];
	[super dealloc];
}

- (id) get: (NSInteger) index {
	return [self node: index].item;
}

- (NSInteger) indexOf: (id) o {
	LRNode* x = myFirst;
	for (int i = 0; i < mySize; i++) {
		if (equals(x->myItem, o)) {
			return i;
		}
		x = x->myNextNode;
	}
	return NSNotFound;
}

- (BOOL) contains: (id) o {
	return [self indexOf: o] != NSNotFound;
}

- (BOOL) remove: (id) o {
	LRNode* x = myFirst;
	for (int i = 0; i < mySize; i++) {
		if (equals(x->myItem, o)) {
			[self unlinkNode: x];
			return YES;
		}
		x = x->myNextNode;
	}
	return NO;
}


- (id) set: (id) o at: (NSInteger) index {
	LRNode* x = [self node: index];
	id ret = x.item;
	x.item = [o retain];
	return [ret autorelease];
}


- (NSObject<JBIterator>*) iterator {
	__block LRNode* cursor = myFirst;
	__block LRNode* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
		prev = cursor;
		cursor = cursor.nextNode;
		return prev.item;
	} hasNextCL: ^BOOL(void) {
		return cursor != nil;
	} removeCL: ^void(void) {
		if (prev != nil) {
			[self unlinkNode: prev];
		} else {
			@throw [JBAbstractIterator badRemove];
		}
	}] autorelease];
}

@end



@implementation LRNode 

@synthesize nextNode = myNextNode, prevNode = myPrevNode, item = myItem;

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item {
	LRNode* ret = [[LRNode alloc] init];
	ret->myItem = item;
	ret->myNextNode = nextNode;
	ret->myPrevNode = prevNode;
	return [ret autorelease];
}

@end
