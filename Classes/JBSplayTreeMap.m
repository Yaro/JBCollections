#import "JBSplayTreeMap.h"


enum {LEFT, RIGHT, ROOT};
//or define?

@interface TMapEntry : MapEntry {
@public
	TMapEntry* myLeft,* myRight,* myPar;
}

@property (readwrite, nonatomic, assign) TMapEntry* left,* right,* par;

- (NSInteger) toParent;
- (BOOL) hasRight;
- (BOOL) hasLeft;
- (void) unlinkParent;
- (void) splay;
- (void) splayOnce;
- (void) rotateWithParent;

@end


@implementation TMapEntry

@synthesize left = myLeft, right = myRight, par = myPar;

- (void) dealloc {
	[super dealloc];
}

- (NSInteger) toParent {
	if (myPar == nil) return ROOT;
	return myPar->myLeft == self ? LEFT : RIGHT;
}

- (void) unlinkParent {
	if ([self toParent] == LEFT) {
		myPar.left = nil;
	}
	else {
		myPar.right = nil;
	}
}

- (void) delink {
	assert(!([self hasLeft] && [self hasRight]));
	assert(myPar != nil);
	TMapEntry* ch = nil;
	if ([self hasLeft]) {
		myLeft->myPar = myPar;
		ch = myLeft;
	} else
	if ([self hasRight]) {
		myRight->myPar = myPar;
		ch = myRight;
	}
	
	if ([self toParent] == LEFT) {
		myPar->myLeft = ch;
	}
	else {
		myPar->myRight = ch;
	}
}

- (BOOL) hasLeft {
	return myLeft != nil;
}

- (BOOL) hasRight {
	return myRight != nil;
}

- (void) rotateWithParent {
	if (myPar == nil) return;
	BOOL isLeft = [self toParent] == LEFT;
	BOOL isParLeft = [myPar toParent] == LEFT;
	TMapEntry* p = myPar;
	TMapEntry* X = myPar->myPar;
	//now we become the appropriate child of X
	myPar = X;
	if (isParLeft) {
		X.left = self;
	} else {
		X.right = self;
	}
	
	p.par = self;
	if (isLeft) {
		p.left = myRight;
		myRight.par = p;
		myRight = p;
	} else {
		p.right = myLeft;
		myLeft.par = p;
		myLeft = p;
	}
}

- (void) splay {
	while (myPar != nil)
		[self splayOnce];
}

- (void) splayOnce {
	TMapEntry* p = myPar;
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

- (NSString*) trace: (int) h {
	NSMutableString* ret = [NSMutableString new];
	for (int i = 0; i < h; i++)
		[ret appendString: @"  "];
	[ret appendString: [self description]];
	[ret appendString: @"\n"];
	if ([self hasLeft]) {
		[ret appendString: [myLeft trace: h + 1]];
	}
	if ([self hasRight]) {
		[ret appendString: [myRight trace: h + 1]];
	}
	return [ret autorelease];
}

@end



@interface JBSplayTreeMap()

- (void) clear: (TMapEntry*) e;
- (void) splayEntry: (TMapEntry*) e;
- (TMapEntry*) firstEntry;
- (TMapEntry*) lastEntry;
- (TMapEntry*) prevEntry: (TMapEntry*) e;
- (TMapEntry*) nextEntry: (TMapEntry*) e;

@end

@implementation JBSplayTreeMap

@synthesize comparator = myComparator, size = mySize;

#if 1
- (int) height: (TMapEntry*) e {
	if (e == nil) return 0;
	int L = [self height: e.left], R = [self height: e.right];
	return 1 + MAX(L, R);
}

- (int) height {
	return [self height: myRoot];
}

- (int) size: (TMapEntry*) e {
	if (e == nil) return 0;
	return 1 + [self size: e.left] + [self size: e.right];
}

- (int) ssize {
	return [self size: myRoot];
}
#endif


- (id) initWithComparator: (NSComparator) comp {
	[super init];
	myComparator = [comp copy];
	return self;
}

- (id) init {
	@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

- (id) initWithKeysAndObjects: (id) firstKey, ... {
	@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

- (id) initWithMap: (id<JBMap>) map {
	@throw [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

- (id) initWithSortedMap: (id) map {
	SEL comparatorSelector = @selector(comparator);
	if ([map respondsToSelector: comparatorSelector]) {
		[self initWithComparator: [map performSelector: comparatorSelector]];
	}
	[self putAll: map];
	return self;
}

- (id) firstKey {
	return [self firstEntry].key;
}

- (id) lastKey {
	return [self lastEntry].key;
}

- (TMapEntry*) firstEntry {
	TMapEntry* e = myRoot;
	while (e.left != nil)
		e = e.left;
	return e;
}

- (TMapEntry*) lastEntry {
	TMapEntry* e = myRoot;
	while (e.right != nil)
		e = e.right;
	return e;
}

- (TMapEntry*) nextEntry: (TMapEntry*) e {
	if ([e hasRight]) {
		e = e.right;
		while ([e hasLeft]) {
			e = e.left;
		}
		return e;
	}
	while ([e toParent] == RIGHT) e = e.par;
	return e.par;
}

- (TMapEntry*) prevEntry: (TMapEntry*) e {
	if ([e hasLeft]) {
		e = e.left;
		while ([e hasRight]) {
			e = e.right;
		}
	}
	while ([e toParent] == LEFT) e = e.par;
	return e.par;
}


- (id) putKey: (id) key withValue: (id) value  {
	if (key == nil || value == nil) {
		@throw [NSException exceptionWithName: @"nil keys or values not allowed" reason: @"" userInfo: nil];
	}
	
	TMapEntry* e = [[TMapEntry alloc] initWithKey: key value: value];
	
	if (myRoot == nil) {
		myRoot = e;
		mySize = 1;
		return nil;
	}
	
	TMapEntry* tEntry = myRoot;
	BOOL added = FALSE;
	while (!added) {
		NSComparisonResult cmp = myComparator(tEntry.key, key);
		if (cmp == NSOrderedSame) {
			[e release];
			id ret = tEntry.value;
			tEntry.value = value;
			return ret;
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
	return nil;
}

- (void) splayEntry: (TMapEntry*) e {
	[e splay];
	myRoot = e;
}

- (id) remove: (id) key {
	TMapEntry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res == NSOrderedSame) {
			id ret = e.value;
			if (mySize == 1) {
				ret = myRoot.value;
				myRoot = nil;
			} else {
				if ([e hasLeft] && [e hasRight]) {
					TMapEntry* q = [self nextEntry: e];
					if (q == nil || q == myRoot) {
						q = [self prevEntry: e];
					}
					[q delink];
					[e->myKey release];
					e->myKey = [q->myKey retain];
					e.value = q.value;
					[q release];
				} else {
					TMapEntry* child = [e hasLeft] ? e->myLeft : e->myRight;
					if (myRoot == e) {
						myRoot = child;
						myRoot->myPar = nil;
					} else {
						[e delink];
					}
					[e release];
				}
			}
			mySize--;
			return ret;
		}
		if (res == NSOrderedDescending) {
			e = e.left;
		} else {
			e = e.right;
		}
	}
	return nil;
}

- (BOOL) containsKey: (id) key {
	TMapEntry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res == NSOrderedSame) return TRUE;
		if (res == NSOrderedDescending) {
			e = e.left;
		} else {
			e = e.right;
		}
	}
	return FALSE;
}

- (NSObject<JBIterator>*) entryIterator {
	__block NSInteger done = 0;
	__block TMapEntry* e = [self firstEntry];
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		id ret = e;
		e = [self nextEntry: e];
		done++;
		return ret;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	}] autorelease];
}

- (NSObject<JBIterator>*) keyIterator {
	__block NSInteger done = 0;
	__block TMapEntry* e = [self firstEntry];
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		id ret = e.key;
		e = [self nextEntry: e];
		done++;
		return ret;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	}] autorelease];
}

- (void) clear {
	[self clear: myRoot];
}

- (void) clear: (TMapEntry*) e {
	if ([e hasLeft]) {
		[self clear: e.left];
	}
	if ([e hasRight]) {
		[self clear: e.right];
	}
	[e release];
}

- (void) dealloc {
	[self clear];
	[super dealloc];
}

- (id) prevKey: (id) key {
	TMapEntry* e = myRoot;
	id ret = nil;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res >= NSOrderedSame) {
			e = e.left;
		} else {
			ret = e.key;
			e = e.right;
		}
	}
	return ret;
}

//copy-paste...
- (id) prevOrEqualKey: (id) key {
	TMapEntry* e = myRoot;
	id ret = nil;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res > NSOrderedSame) {
			e = e.left;
		} else {
			ret = e.key;
			e = e.right;
		}
	}
	return ret;
}

- (id) nextKey: (id) key {
	TMapEntry* e = myRoot;
	id ret = nil;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res <= NSOrderedSame) {
			e = e.right;
		} else {
			ret = e.key;
			e = e.left;
		}
	}
	return ret;
}

//don't like copy-paste
- (id) nextOrEqualKey: (id) key {
	TMapEntry* e = myRoot;
	id ret = nil;
	while (e != nil) {
		NSComparisonResult res = myComparator(e.key, key);
		if (res < NSOrderedSame) {
			e = e.right;
		} else {
			ret = e.key;
			e = e.left;
		}
	}
	return ret;
}

@end
