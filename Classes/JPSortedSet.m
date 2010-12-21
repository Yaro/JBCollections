#import "JPSortedSet.h"

#define ISRED(n) ((n) != nil && (n.red))

@implementation JPSortedSet

#if 1

- (int) height: (JPRBNode*) e {
	if (e == nil) return 0;
	int L = [self height: e.left], R = [self height: e.right];
	return 1 + MAX(L, R);
}

- (int) height {
	return [self height: myRoot];
}

- (int) size: (JPRBNode*) e {
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


- (void) dealloc {
	[myRoot release];
	[myComparator release];
	[super dealloc];	
}

- (NSComparisonResult) compare: (NSObject*) obj1 with: (NSObject*) obj2 {
	return myComparator(obj1, obj2);	
}

- (NSObject*) max: (NSObject*) obj1 with: (NSObject*) obj2 {
	NSComparisonResult res = [self compare: obj1 with: obj2];
	if (res == NSOrderedAscending) return obj2;
	return obj1;
}

- (NSObject*) min: (NSObject*) obj1 with: (NSObject*) obj2 {
	NSComparisonResult res = [self compare: obj1 with: obj2];
	if (res == NSOrderedDescending) return obj2;
	return obj1;
}

- (BOOL) node: (JPRBNode*) node contains: (NSObject*) obj {
	if (node == nil) return NO;
	
	NSComparisonResult res = [self compare: obj with: node.value];
	
	if (res == NSOrderedSame) return YES;
	
	if (res == NSOrderedAscending) {
		return [self node: node.left contains: obj];	
	} else {
		return [self node: node.right contains: obj];
	}
}

- (JPRBNode*) insert: (NSObject*) obj to: (JPRBNode*) node {
	if (node == nil) {
		return [[[JPRBNode alloc] initWithValue: obj] autorelease];
	}
	
	NSComparisonResult res = [self compare: obj with: node.value];
	
	if (res == NSOrderedAscending) {
		node.left = [self insert: obj to: node.left];
	} else {
		node.right = [self insert: obj to: node.right];
	}
	
	return [node fixUp];
}

- (int) count {
	return myCount;
}

- (BOOL) add: (NSObject*) obj {
	if ([self node: myRoot contains: obj]) return TRUE;
    JPRBNode* newRoot = [self insert: obj to: myRoot];
    [newRoot retain];
    [myRoot release];
	myRoot = newRoot;
	if (myRoot != nil) {
		myRoot.red = NO;
	}
	myCount++;
	return FALSE;
}

- (JPRBNode*) delete: (NSObject*) obj from: (JPRBNode*) node {
    JPRBNode* result = node;
    NSComparisonResult res = [self compare: obj with: node.value];
	
    if (res == NSOrderedAscending) {
        if (!ISRED(result.left) && !ISRED(result.left.left))  {
            result = [result moveRedLeft];
        }
        result.left = [self delete: obj from: result.left];
    } else {
        if (ISRED(result.left)) {
            result = [result rotateRight];
        }
		
        if ([self compare: obj with: result.value] == NSOrderedSame && result.right == nil) {
            return nil;
        }
		
        if (!ISRED(result.right) && !ISRED(result.right.left)) {
            result = [result moveRedRight];
        }
		
        if ([self compare: obj with: result.value] == NSOrderedSame) {
			result.value = [result.right min].value;
			result.right = [result.right deleteMin];
		} else {
			result.right = [self delete: obj from: result.right];
		}
    }
	
	return [result fixUp];
}

- (BOOL) remove: (NSObject*) obj {
	if (![self node: myRoot contains: obj]) return FALSE;
	if (myRoot == nil || ![self node: myRoot contains: obj]) return FALSE;
	JPRBNode* newRoot = [self delete: obj from: myRoot];
	[newRoot retain];
	[myRoot release];
	myRoot = newRoot;
	if (myRoot != nil) {
		myRoot.red = NO;
	}
	myCount--;
	return TRUE;
}

- (BOOL) contains: (NSObject*) obj {
	return [self node: myRoot contains: obj];	
}

- (NSObject*) nextTo: (NSObject*) obj inNode: (JPRBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: obj with: node.value];
	if (res == NSOrderedSame || res == NSOrderedDescending) {
		return [self nextTo: obj inNode: node.right];
	} else {
		NSObject* current = node.value;
		NSObject* candidate = [self	 nextTo: obj inNode: node.left];
		if (candidate != nil) {
			current = [self min: current with: candidate];
		}
		return current;
	}
}	

- (NSObject*) next: (NSObject*) obj {
	return [self nextTo: obj inNode: myRoot];
}

- (NSObject*) prevTo: (NSObject*) obj inNode: (JPRBNode*) node {
	if (node == nil) return nil;
	
    NSComparisonResult res = [self compare: obj with: node.value];
	if (res == NSOrderedSame || res == NSOrderedAscending) {
		return [self prevTo: obj inNode: node.left];
	} else {
		NSObject* current = node.value;
		NSObject* candidate = [self	prevTo: obj inNode: node.right];
		if (candidate != nil) {
			current = [self max: current with: candidate];
		}
		return current;
	}
}	

- (NSObject*) prev: (NSObject*) obj {
	return [self prevTo: obj inNode: myRoot];
}

- (NSObject*) first {
	if (myRoot == nil) return nil;
	return [myRoot min].value;
}

- (NSObject*) last {
	if (myRoot == nil) return nil;
	return [myRoot max].value;
}


- (NSString*) description {
	NSMutableString* result = [NSMutableString new];
	
	[result appendString: @"JPSortedSet("];
	
	BOOL first = YES;
	for (NSObject* o in [self toArray]) {
		if (!first) {
			[result appendFormat: @", %@", o];	
		} else {
			first = NO;
			[result appendFormat: @"%@", o];
		}
	}
	
	[result appendString: @")"];
	
	return [result autorelease];
}

- (NSArray*) toArray {
	NSMutableArray* result = [NSMutableArray new];
	if (myRoot != nil) {
		[myRoot collectToArray: result];	
	}
	return [result autorelease];
}


@end


@implementation JPRBNode 

- (id) initWithValue: (NSObject*) value {
	[super init];
	self.value = value;
	self.red = YES;
	return self;
}

- (void) dealloc {
	[myValue release];
	[myLeft release];
	[myRight release];
	[super dealloc];	
}

@synthesize red = myRed;
@synthesize value = myValue;
@synthesize left = myLeft;
@synthesize right = myRight;

- (NSString*) trace: (int) h {
	NSMutableString* ret = [NSMutableString new];
	for (int i = 0; i < h; i++)
		[ret appendString: @"  "];
	[ret appendString: [myValue description]];
	[ret appendString: @"\n"];
	if (self.left != nil) {
		[ret appendString: [myLeft trace: h + 1]];
	}
	if (self.right != nil) {
		[ret appendString: [myRight trace: h + 1]];
	}
	return [ret autorelease];
}

- (JPRBNode*) rotateLeft {
	JPRBNode* result = self.right;
	self.right = result.left;
	result.left	= self;
	result.red = result.left.red;
	result.left.red = YES;
	return result;
}

- (JPRBNode*) rotateRight {
	JPRBNode* result = self.left;
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

- (JPRBNode*) moveRedRight {
	JPRBNode* result = self;
	[result colorFlip];	
	if (ISRED(result.left.left)) {
		result = [result rotateRight];
		[result colorFlip];
	}
	return result;
}

- (JPRBNode*) moveRedLeft {
	JPRBNode* result = self;
	[result colorFlip];
	if (ISRED(result.right.left)) {
		result.right = [result.right rotateRight];
		result = [result rotateLeft];
		[result colorFlip];
	}
	return result;
}
- (JPRBNode*) fixUp {
	JPRBNode* result = self;
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

- (JPRBNode*) min {
	if (self.left != nil) return [self.left	min];
	return self;
}

// lol
- (JPRBNode*) max {
	if (self.right != nil) return [self.right min];
	return self;
}

- (JPRBNode*) deleteMin {
	JPRBNode* h = self;
	if (h.left == nil) {
		return nil;
	}
	
	if (!ISRED(h.left) && !ISRED(h.left.left)) {
		h = [h moveRedLeft];
	}
	
	h.left = [h.left deleteMin];
	
	return [h fixUp];
}

- (void) collectToArray: (NSMutableArray*) array {
	if (self.left != nil) {
		[self.left collectToArray: array];
	}
	[array addObject: myValue];
	if (self.right != nil) {
		[self.right collectToArray: array];
	}
}


@end