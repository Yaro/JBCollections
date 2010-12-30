#import "JBSplayTreeMap.h"


enum {LEFT, RIGHT, ROOT};
typedef int CTYPE;

@interface TMapEntry : JBMapEntry {
@public
	TMapEntry* myLeft,* myRight;
}

@property (readwrite, nonatomic, assign) TMapEntry* left,* right;

- (NSInteger) toParent: (TMapEntry*) p;
- (BOOL) hasRight;
- (BOOL) hasLeft;
- (TMapEntry*) min;
- (TMapEntry*) max;
- (TMapEntry*) unlinkNext;
- (void) splayOnce: (TMapEntry*) p and: (TMapEntry*) X and: (TMapEntry*) Xp;
- (void) rotateWithParent: (TMapEntry*) p and: (TMapEntry*) X;

@end


@implementation TMapEntry

@synthesize left = myLeft, right = myRight;

- (void) dealloc {
	[super dealloc];
}

- (void) delink: (TMapEntry*) par {
	TMapEntry* ch = nil;
	if ([self hasLeft]) {
		ch = self->myLeft;
	} else {
		ch = self->myRight;
	}
	
	if (par->myLeft == self) {
		par->myLeft = ch;
	}
	else {
		par->myRight = ch;
	}
}

- (BOOL) hasLeft {
	return myLeft != nil;
}

- (BOOL) hasRight {
	return myRight != nil;
}

- (TMapEntry*) min {
	TMapEntry* e = self;
	while (e->myLeft != nil) {
		e = e->myLeft;
	}
	return e;
}

- (TMapEntry*) max {
	TMapEntry* e = self;
	while (e->myRight != nil) {
		e = e->myRight;
	}
	return e;
}

- (TMapEntry*) unlinkNext {
	if (myRight == nil) {
		return nil;
	}
	
	TMapEntry* e = myRight,* ret = nil;
	if (e->myLeft == nil) {
		[e delink: self];
		return e;
	}
	
	while (e->myLeft->myLeft != nil) {
		e = e->myLeft;
	}
	
	ret = e->myLeft;
	e->myLeft = ret->myRight;
	return ret;
}

- (void) rotateWithParent: (TMapEntry*) p and: (TMapEntry*) X {
	if (p == nil) return;
	if (X != nil) {
		if (X->myLeft == p) {
			X->myLeft = self;
		}
		else {
			X->myRight = self;
		}
	}
	if (p->myLeft == self) {
		p->myLeft = myRight;
		myRight = p;
	} 
	else {
		p->myRight = myLeft;
		myLeft = p;
	}
}

- (CTYPE) toParent: (TMapEntry*) p {
	if (p == nil) return ROOT;
	return p->myLeft == self ? LEFT : RIGHT;
}

- (void) splayOnce: (TMapEntry*) p and: (TMapEntry*) X and: (TMapEntry*) Xp {
	if (X == nil) {
		[self rotateWithParent: p and: X];
		return;
	}
	if ([self toParent: p] == [p toParent: X]) {
		[p rotateWithParent: X and: Xp];
		[self rotateWithParent: p and: Xp];
	} else {
		[self rotateWithParent: p and: X];
		[self rotateWithParent: X and: Xp];
	}
}

// debug feature
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
- (BOOL) splayEntry: (TMapEntry*) e into: (TMapEntry*) Xp and: (TMapEntry*) X;
- (TMapEntry*) nextEntry: (TMapEntry*) e;
- (TMapEntry*) max: (TMapEntry*) e1 with: (TMapEntry*) e2;

@end

@implementation JBSplayTreeMap

@synthesize comparator = myComparator, size = mySize;


// debug only
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


- (id) initWithComparator: (NSComparator) cmp {
	[super init];
	myComparator = [cmp copy];
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
	if ([map respondsToSelector: comparatorSelector]) {
		[self initWithComparator: [map performSelector: comparatorSelector]];
	}
	[self putAll: map];
	return self;
}

- (TMapEntry*) max: (id) o1 with: (id) o2 {
	return myComparator(o1, o2) == NSOrderedAscending ? o2 : o1;
}

- (NSComparisonResult) compare: (id) o1 with: (id) o2 {
	return myComparator(o1, o2);
}

- (id) firstKey {
	return [self firstEntry].key;
}

- (id) lastKey {
	return [self lastEntry].key;
}

- (TMapEntry*) firstEntry {
	return [myRoot min];
}

- (TMapEntry*) lastEntry {
	return [myRoot max];
}

//not to use in iterator after all
- (TMapEntry*) nextEntry: (TMapEntry*) e {
	TMapEntry* node = myRoot,* ret = nil;
	while (node != nil) {
		NSComparisonResult res = [self compare: node->myKey with: e->myKey];
		if (res <= NSOrderedSame) {
			node = node->myRight;
		} else {
			ret = node;
			node = node->myLeft;
		}
	}
	return ret;
}


- (id) putKey: (id) key withValue: (id) value  {
	if (key == nil || value == nil) {
		@throw [NSException exceptionWithName: @"nil keys or values not allowed" reason: @"" userInfo: nil];
	}
	
	if (myRoot == nil) {
		myRoot = [[TMapEntry alloc] initWithKey: key value: value];
		mySize = 1;
		return nil;
	}
	
	TMapEntry* e,* tEntry = myRoot;
	BOOL added = FALSE;
	while (!added) {
		NSComparisonResult cmp = [self compare: tEntry.key with: key];
		if (cmp == NSOrderedSame) {
			id ret = [tEntry.value retain];
			tEntry.value = value;
			return [ret autorelease];
		}
		else if (cmp == NSOrderedDescending) {
			if (tEntry.left == nil) {
				tEntry.left = (e = [[TMapEntry alloc] initWithKey: key value: value]);
				added = TRUE;
			} else {
				tEntry = tEntry.left;
			}
		} else {
			if (tEntry.right == nil) {
				tEntry.right = (e = [[TMapEntry alloc] initWithKey: key value: value]);
				added = TRUE;
			} else {
				tEntry = tEntry.right;
			}
		}
	}
	mySize++;
	[self splayEntry: e];
	return nil;
}

- (void) splayEntry: (TMapEntry*) e {
	BOOL even = [self splayEntry: e into: myRoot and: nil];
	if (!even) {
		[e splayOnce: myRoot and: nil and: nil];
	}
	myRoot = e;
}

- (BOOL) splayEntry: (TMapEntry*) e into: (TMapEntry*) X and: (TMapEntry*) PX {
	if (e == X) {
		return TRUE;
	}
	TMapEntry* CX = (myComparator(X->myKey, e->myKey) == NSOrderedDescending) ? X->myLeft : X->myRight;
	BOOL even = [self splayEntry: e into: CX and: X];
	if (!even) {
		[e splayOnce: CX and: X and: PX];
	}
	return !even;
}

- (id) remove: (id) key {
	TMapEntry* e = myRoot,* par = e;
	while (e != nil) {
		NSComparisonResult res = [self compare: e.key with: key];
		if (res == NSOrderedSame) {
			id ret = [e.value retain];
			TMapEntry* ne = [e unlinkNext];
			if (ne == nil) {
				if (e == par) {
					myRoot = e->myLeft;
				} else {
					if ([e toParent: par] == LEFT) {
						par->myLeft = e->myLeft;
					} else {
						par->myRight = e->myLeft;
					}
				}
			} else {
				e.value = ne.value;
				e.key = ne.key;
				[ne release];
			}
			mySize--;
			return [ret autorelease];
		} else if (res == NSOrderedDescending) {
			par = e;
			e = e->myLeft;
		} else {
			par = e;
			e = e->myRight;
		}
	}
	return nil;
}

- (BOOL) containsKey: (id) key {
	TMapEntry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = [self compare: e.key with: key];
		if (res == NSOrderedSame) return TRUE;
		if (res == NSOrderedDescending) {
			e = e->myLeft;
		} else {
			e = e->myRight;
		}
	}
	return FALSE;
}

- (NSObject<JBIterator>*) entryIterator {
	__block NSInteger done = 0;
	__block TMapEntry* e = [self firstEntry];
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (e == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
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
		if (e == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
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
		[self clear: e->myLeft];
	}
	if ([e hasRight]) {
		[self clear: e->myRight];
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
