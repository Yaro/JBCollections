#import "JBTreeMap.h"

#define ISRED(n) ((n) != nil && (n.red))

@interface RBNode : JBMapEntry {
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




@interface JBTreeMap()

- (RBNode*) getNode: (id) key;

@end

@implementation JBTreeMap

@synthesize size = mySize, comparator = myComparator;

#if 1
- (int) height: (RBNode*) e {
	if (e == nil) return 0;
	int L = [self height: e.left], R = [self height: e.right];
	return 1 + MAX(L, R);
}

- (int) height {
	return [self height: myRoot];
}

- (int) size: (RBNode*) e {
	if (e == nil) return 0;
	return 1 + [self size: e.left] + [self size: e.right];
}

- (int) ssize {
	return [self size: myRoot];
}
#endif

- (id) initWithComparator: (NSComparator) comparator {
	[super init];
	myComparator = [comparator copy];
	return self;
}

- (id) init {
	@throw [JBExceptions needComparator];
}

- (id) initWithKeysAndObjects: (id) firstKey, ... {
	@throw [JBExceptions needComparator];
}

- (id) initWithMap: (id<JBMap>) map {
	@throw [JBExceptions needComparator];
}

- (id) initWithSortedMap: (id) map {
	SEL comparatorSelector = @selector(comparator);
	if (![map respondsToSelector: comparatorSelector]) {
		@throw [NSException exceptionWithName: @"comparator missing" reason: @"no <comparator> method defined" userInfo: nil];
	}
	[self initWithComparator: [map performSelector: comparatorSelector]];
	[self putAll: map];
	return self;
}

+ (id) withComparator: (NSComparator) comparator {
	return [[[self alloc] initWithComparator: comparator] autorelease];
}

- (void) dealloc {
	[myRoot release];
	[myComparator release];
	[super dealloc];	
}

- (NSComparisonResult) compare: (id) key1 with: (id) key2 {
	return myComparator(key1, key2);	
}

- (id) max: (id) key1 with: (id) key2 {
	NSComparisonResult res = [self compare: key1 with: key2];
	if (res == NSOrderedAscending) return key2;
	return key1;
}

- (id) min: (id) key1 with: (id) key2 {
	NSComparisonResult res = [self compare: key1 with: key2];
	return res == NSOrderedDescending ? key2 : key1;
}

- (BOOL) node: (RBNode*) node containsKey: (id) key {
	if (node == nil) return NO;
	
	NSComparisonResult res = [self compare: key with: node.key];
	
	if (res == NSOrderedSame) return YES;
	
	if (res == NSOrderedAscending) {
		return [self node: node.left containsKey: key];	
	} else {
		return [self node: node.right containsKey: key];
	}
}

- (RBNode*) getNode: (id) key {
	RBNode* node = myRoot;
	while (node != nil) {
		NSComparisonResult res = [self compare: key with: node.key];
		if (res == NSOrderedSame) return node;
		if (res == NSOrderedAscending) {
			node = node.left;
		} else {
			node = node.right;
		}
	}
	return nil;
}

- (RBNode*) insertKey: (id) key withValue: (id) value to: (RBNode*) node {
	if (node == nil) {
		return [[[RBNode alloc] initWithKey: key value: value] autorelease];
	}
	
	NSComparisonResult res = [self compare: key with: node.key];
	
	if (res == NSOrderedAscending) {
		node.left = [self insertKey: key withValue: value to: node.left];
	} else {
		node.right = [self insertKey: key withValue: value to: node.right];
	}
	
	return [node fixUp];
}

- (id) putKey: (id) key withValue: (id) value {
	RBNode* node = [self getNode: (id) key];
	if (node != nil) {
		id oldVal = [node->myValue retain];
		node.value = value;
		return [oldVal autorelease];
	}
	RBNode* newRoot = [self insertKey: key withValue: value to: myRoot];
	[newRoot retain];
	[myRoot release];
	myRoot = newRoot;
	myRoot.red = NO;
	mySize++;
	return nil;
}


- (RBNode*) delete: (id) key from: (RBNode*) node {
    RBNode* result = node;
    NSComparisonResult res = [self compare: key with: node.key];
	
    if (res == NSOrderedAscending) {
        if (!ISRED(result.left) && !ISRED(result.left.left))  {
            result = [result moveRedLeft];
        }
        result.left = [self delete: key from: result.left];
    } else {
        if (ISRED(result.left)) {
            result = [result rotateRight];
        }
		
        if ([self compare: key with: result.key] == NSOrderedSame && result.right == nil) {
            return nil;
        }
		
        if (!ISRED(result.right) && !ISRED(result.right.left)) {
            result = [result moveRedRight];
        }
		
        if ([self compare: key with: result.key] == NSOrderedSame) {
			RBNode* rmnode = [result.right min];
			result.key = rmnode.key;
			result.value = rmnode.value;
			//check
			result.right = [result.right deleteMin];
		} else {
			result.right = [self delete: key from: result.right];
		}
    }
	
	return [result fixUp];
}

- (id) remove: (id) key {
	RBNode* node = [self getNode: key];
	if (node == nil) {
		return nil;
	}
	
	id oldVal = [node.value retain];
	
	RBNode* newRoot = [self delete: key from: myRoot];
	[newRoot retain];
	[myRoot release];
	myRoot = newRoot;
	if (myRoot != nil) {
		myRoot.red = NO;
	}
	mySize--;
	return [oldVal autorelease];
}



- (BOOL) containsKey: (id) key {
	return [self node: myRoot containsKey: key];	
}



- (RBNode*) nextEntry: (id) key inNode: (RBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: key with: node.key];
	if (res == NSOrderedSame || res == NSOrderedDescending) {
		return [self nextEntry: key inNode: node.right];
	} else {
		RBNode* current = node;
		RBNode* candidate = [self nextEntry: key inNode: node.left];
		if (candidate != nil && [self compare: candidate.key with: current.key] == NSOrderedAscending) {
			current = candidate;
		}
		return current;
	}
}

- (id) nextKey: (id) key {
	return [self nextEntry: key inNode: myRoot].key;
}



- (RBNode*) prevEntry: (id) key inNode: (RBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: key with: node.key];
	if (res == NSOrderedSame || res == NSOrderedAscending) {
		return [self prevEntry: key inNode: node.left];
	} else {
		RBNode* current = node;
		RBNode* candidate = [self prevEntry: key inNode: node.right];
		if (candidate != nil && [self compare: candidate.key with: current.key] == NSOrderedDescending) {
			current = candidate;
		}
		return current;
	}
}	

- (id) prevKey: (id) key {
	return [self prevEntry: key inNode: myRoot].key;
}



- (id) nextOrEqualTo: (id) key inNode: (RBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: key with: node.key];
	if (res == NSOrderedDescending) {
		return [self nextOrEqualTo: key inNode: node.right];
	} else {
		id current = node.key;
		id candidate = [self nextOrEqualTo: key inNode: node.left];
		if (candidate != nil) {
			current = [self min: current with: candidate];
		}
		return current;
	}
}

- (id) nextOrEqualKey: (id) key {
	return [self nextOrEqualTo: key inNode: myRoot];
}



- (id) prevOrEqualTo: (id) key inNode: (RBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: key with: node.key];
	if (res == NSOrderedAscending) {
		return [self prevOrEqualTo: key inNode: node.left];
	} else {
		id current = node.key;
		id candidate = [self prevOrEqualTo: key inNode: node.right];
		if (candidate != nil) {
			current = [self max: current with: candidate];
		}
		return current;
	}
}	

- (id) prevOrEqualKey: (id) key {
	return [self prevOrEqualTo: key inNode: myRoot];
}




- (id) firstKey {
	if (myRoot == nil) return nil;
	return [myRoot min].key;
}

- (id) lastKey {
	if (myRoot == nil) return nil;
	return [myRoot max].key;
}

// O(n*log(n)) time
- (NSObject<JBIterator>*) entryIterator {
	__block RBNode* cursor = [myRoot min],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
		prev = cursor;
		cursor = [self nextEntry: cursor.key inNode: myRoot];
		return prev;
	} hasNextCL: ^BOOL(void) {
		return cursor != nil;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];
	}] autorelease];
}

- (NSObject<JBIterator>*) keyIterator {
	__block RBNode* cursor = [myRoot min],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
		prev = cursor;
		cursor = [self nextEntry: cursor.key inNode: myRoot];
		return prev.key;
	} hasNextCL: ^BOOL(void) {
		return cursor != nil;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];		
	}] autorelease];
}

- (void) clear {
	[myRoot release];
	myRoot = nil;
	mySize = 0;
}


@end


@implementation RBNode

@synthesize red = myRed;
@synthesize left = myLeft;
@synthesize right = myRight;

- (id) initWithKey: (id) key value: (id) value {
	[super initWithKey: key value: value];
	myRed = YES;
	return self;
}

- (NSString*) trace: (int) h {
	NSMutableString* ret = [NSMutableString new];
	for (int i = 0; i < h; i++)
		[ret appendString: @"  "];
	[ret appendString: [self description]];
	[ret appendString: @"\n"];
	if (self.left != nil) {
		[ret appendString: [myLeft trace: h + 1]];
	}
	if (self.right != nil) {
		[ret appendString: [myRight trace: h + 1]];
	}
	return [ret autorelease];
}

- (RBNode*) rotateLeft {
	RBNode* result = self.right;
	self.right = result.left;
	result.left	= self;
	result.red = result.left.red;
	result.left.red = YES;
	return result;
}

- (RBNode*) rotateRight {
	RBNode* result = self.left;
	self.left = result.right;
	result.right = self;
	result.red =  result.right.red;
	result.right.red = YES;
	return result;
}

- (void) colorFlip {
	self.red = !self.red;
	self.left.red = !self.left.red;
	self.right.red = !self.right.red;
}

- (RBNode*) moveRedRight {
	RBNode* result = self;
	[result colorFlip];	
	if (ISRED(result.left.left)) {
		result = [result rotateRight];
		[result colorFlip];
	}
	return result;
}

- (RBNode*) moveRedLeft {
	RBNode* result = self;
	[result colorFlip];
	if (ISRED(result.right.left)) {
		result.right = [result.right rotateRight];
		result = [result rotateLeft];
		[result colorFlip];
	}
	return result;
}
- (RBNode*) fixUp {
	RBNode* result = self;
	if (ISRED(result.right)) {
		result = [result rotateLeft];	
	}
	if (ISRED(result.left) && ISRED(result.left.left)) {
		result = [result rotateRight];	
	}
	if (ISRED(result.left) && ISRED(result.right)) {
		[result colorFlip];	
	}
	return result;
}

- (RBNode*) min {
	if (self.left != nil) return [self.left	min];
	return self;
}

- (RBNode*) max {
	if (self.right != nil) return [self.right max];
	return self;
}

- (RBNode*) deleteMin {
	RBNode* h = self;
	if (h.left == nil) {
		return nil;
	}
	
	if (!ISRED(h.left) && !ISRED(h.left.left)) {
		h = [h moveRedLeft];
	}
	
	h.left = [h.left deleteMin];
	
	return [h fixUp];
}

@end