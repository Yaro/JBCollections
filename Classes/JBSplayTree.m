#import "JBSplayTree.h"
#import "JBArrays.h"

enum {LEFT, RIGHT, ROOT};
//or define?

@interface JBSplayTree()

- (void) clear: (Entry*) e;
- (void) splayEntry: (Entry*) e;

@end



@implementation JBSplayTree


- (id) init {
	[super init];
	myRoot = nil;
	return self;
}

- (id) initWithCollection: (NSObject<JBCollection>*) c {
	[super init];
	[self addAll: c];
	return self;
}

- (id*) toArray {
	if (mySize == 0) return nil;
	id* ret = arrayWithLength(mySize);
	Entry* fe = [self firstEntry];
	for (int i = 0; i < mySize; i++) {
		ret[i] = fe;
		fe = [self nextEntry: fe];
	}
	return ret;
}

- (Entry*) firstEntry {
	Entry* e = myRoot;
	while (e.left != nil)
		e = e.left;
	return e;
}

- (Entry*) lastEntry {
	Entry* e = myRoot;
	while (e.right != nil)
		e = e.right;
	return e;
}

- (Entry*) nextEntry: (Entry*) e {
	while ([e toParent] == RIGHT) e = e.par;
	if (![e hasRight]) return nil;
	e = e.right;
	while ([e hasLeft]) e = e.left;
	return e;
}

- (Entry*) prevEntry: (Entry*) e {
	while ([e toParent] == LEFT) e = e.par;
	if (![e hasLeft]) return nil;
	e = e.left;
	while ([e hasRight]) e = e.right;
	return e;
}


- (BOOL) add: (NSObject*) o {
	Entry* e = [[Entry alloc] initWithObject: o];
	
	if (myRoot == nil) {
		myRoot = e;
		return TRUE;
	}
	
	Entry* tEntry = myRoot;
	BOOL added = FALSE;
	while (!added) {
		NSComparisonResult cmp = myComparator(tEntry.o, o);
		if (cmp == NSOrderedSame) {
			[e release];
			return FALSE;
		}
		else if (cmp == NSOrderedDescending) {
			if (tEntry.left == nil) {
				tEntry.left = e;
				e.par = tEntry;
				added = TRUE;
			} else tEntry = tEntry.left;
		} else {
			if (tEntry.right == nil) {
				tEntry.right = e;
				e.par = tEntry;
				added = TRUE;
			} else tEntry = tEntry.right;
		}
	}
	mySize++;
	[self splayEntry: e];
	return TRUE;
}

- (void) splayEntry: (Entry*) e {
	[e splay];
	myRoot = e;
}

- (BOOL) remove: (NSObject*) o {
	Entry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.o, o);
		if (res == NSOrderedSame) {
			if (mySize == 1) {
				[myRoot release];
				myRoot = nil;
			} else {
				Entry* q;
				if ((q = [self nextEntry: e]) == nil)
					q = [self prevEntry: e];
				q.left = e.left;
				q.right = e.right;
				[q unlinkParent];
				q.par = e.par;
				[e release];
				[self splayEntry: q];
			}
			mySize--;
			return TRUE;
		}
		if (res == NSOrderedDescending) e = e.left;
		else e = e.right;
	}
	return FALSE;
}

- (BOOL) contains: (id) o {
	Entry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.o, o);
		if (res == NSOrderedSame) return TRUE;
		if (res == NSOrderedDescending) e = e.left;
		else e = e.right;
	}
	return FALSE;
}

- (void) clear {
	[self clear: myRoot];
}

- (void) clear: (Entry*) e {
	if (e.left != nil) [self clear: e.left];
	if (e.right != nil) [self clear: e.right];
	[e release];
}

@end

@implementation Entry

@synthesize o = myO, left = myLeft, right = myRight, par = myPar;

- (void) dealloc {
	[myO release];
	[super dealloc];
}

- (id) initWithObject: (id) o {
	[super init];
	myO = o;
	return self;
}

- (NSInteger) toParent {
	if (myPar == nil) return ROOT;
	return myPar->myLeft == self ? LEFT : RIGHT;
}

- (void) unlinkParent {
	if ([self toParent] == LEFT)
		myPar.left = nil;
	else
		myPar.right = nil;
}

- (BOOL) hasLeft {
	return myLeft != nil;
}

- (BOOL) hasRight {
	return myRight != nil;
}

- (void) rotateWithParent {
	if (myPar == nil) return;
	Entry* p = myPar;
	myPar = p.par;
	p.par = self;
	if ([self toParent] == LEFT) {
		myRight = p;
		p.left = myRight;
	} else {
		myLeft = p;
		p.right = myLeft;
	}
}

- (void) splay {
	while (myPar != nil)
		[self splayOnce];
}

- (void) splayOnce {
	Entry* p = myPar;
	if (p.par == nil) {
		[self rotateWithParent];
		return;
	}
	if ([self toParent] == [p toParent]) {
		[p rotateWithParent];
		[self rotateWithParent];
	} else {
		[self rotateWithParent];
		[self rotateWithParent];
	}
}

@end