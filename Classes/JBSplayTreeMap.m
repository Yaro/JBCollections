#import "JBSplayTreeMap.h"


enum {LEFT, RIGHT, ROOT};
typedef int CTYPE;

@interface TMapEntry : JBMapEntry {
@public
	TMapEntry* myLeft,* myRight,* myPar;
}

@property (readwrite, nonatomic, assign) TMapEntry* left,* right,* par;

- (CTYPE) toParent;
- (BOOL) hasRight;
- (BOOL) hasLeft;
- (TMapEntry*) min;
- (TMapEntry*) max;
- (TMapEntry*) unlinkNext;
- (void) rotateWithParent;
- (id) initWithKey: (id) key value: (id) value parent: (TMapEntry*) par;

@end


@implementation TMapEntry

@synthesize left = myLeft, right = myRight, par = myPar;

- (id) initWithKey: (id) key value: (id) value parent: (TMapEntry*) par {
	[self initWithKey: key value: value];
	myPar = par;
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) delink {
	TMapEntry* ch = nil;
	if ([self hasLeft]) {
		ch = self->myLeft;
	} else {
		ch = self->myRight;
	}
	
	ch.par = myPar;
	
	if (myPar->myLeft == self) {
		myPar->myLeft = ch;
	} else {
		myPar->myRight = ch;
	}
}

- (BOOL) hasLeft {
	return myLeft != nil;
}

- (BOOL) hasRight {
	return myRight != nil;
}

- (BOOL) isRoot {
	return myPar == nil;
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
		[e delink];
		return e;
	}
	
	while (e->myLeft->myLeft != nil) {
		e = e->myLeft;
	}
	

	ret = e->myLeft;
	[ret delink];
	return ret;
}

- (void) rotateWithParent {
	if (myPar == nil) return;
	TMapEntry* X = myPar->myPar;
	if (X != nil) {
		if (X->myLeft == myPar) {
			X->myLeft = self;
		} else {
			X->myRight = self;
		}
	}
	if (myPar->myLeft == self) {
		myPar->myLeft = myRight;
		myLeft.par = myPar;
		myRight = myPar;
	} else {
		myPar->myRight = myLeft;
		myRight.par = myPar;
		myLeft = myPar;
	}
	myPar->myPar = self;
	myPar = X;
}

- (CTYPE) toParent {
	if (myPar == nil) return ROOT;
	return myPar->myLeft == self ? LEFT : RIGHT;
}

@end



@interface JBSplayTreeMap()

- (void) clear: (TMapEntry*) e;
- (TMapEntry*) firstEntry;
- (TMapEntry*) lastEntry;
- (TMapEntry*) nextEntry: (TMapEntry*) e;
- (TMapEntry*) max: (TMapEntry*) e1 with: (TMapEntry*) e2;
- (NSComparisonResult) compare: (id) o1 with: (id) o2;
- (void) splay: (TMapEntry*) e;
- (void) splayOnce: (TMapEntry*) e;

@end

@implementation JBSplayTreeMap

@synthesize comparator = myComparator, size = mySize;


- (id) initWithComparator: (NSComparator) cmp {
	[super init];
	myComparator = [cmp copy];
	return self;
}

+ (id) withComparator: (NSComparator) comparator {
	return [[[self alloc] initWithComparator: comparator] autorelease];
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

- (TMapEntry*) firstEntry {
	return [myRoot min];
}

- (TMapEntry*) lastEntry {
	return [myRoot max];
}

- (id) firstKey {
	return [self firstEntry].key;
}

- (id) lastKey {
	return [self lastEntry].key;
}

- (TMapEntry*) nextEntry: (TMapEntry*) e {
	if ([e hasRight]) {
		e = e->myRight;
		while ([e hasLeft]) {
			e = e->myLeft;
		}
		return e;
	}
	while ([e toParent] == RIGHT) {
		e = e->myPar;
	}
	return e->myPar;
}


- (void) splay: (TMapEntry*) e {
	while (e->myPar != nil) {
		[self splayOnce: e];
	}
	myRoot = e;
}

- (void) splayOnce: (TMapEntry*) e {
	TMapEntry* p = e->myPar;
	if (p->myPar == nil) {
		[e rotateWithParent];
		return;
	}
	if ([e toParent] == [p toParent]) {
		[p rotateWithParent];
		[e rotateWithParent];
	} else {
		[e rotateWithParent];
		[e rotateWithParent];
	}
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
	BOOL added = NO;
	while (!added) {
		NSComparisonResult cmp = [self compare: tEntry.key with: key];
		if (cmp == NSOrderedSame) {
			id ret = [tEntry.value retain];
			tEntry.value = value;
			return [ret autorelease];
		}
		else if (cmp == NSOrderedDescending) {
			if (tEntry.left == nil) {
				tEntry.left = (e = [[TMapEntry alloc] initWithKey: key value: value parent: tEntry]);
				added = YES;
			} else {
				tEntry = tEntry.left;
			}
		} else {
			if (tEntry.right == nil) {
				tEntry.right = (e = [[TMapEntry alloc] initWithKey: key value: value parent: tEntry]);
				added = YES;
			} else {
				tEntry = tEntry.right;
			}
		}
	}
	mySize++;
	[self splay: e];
	return nil;
}

- (id) remove: (id) key {
	TMapEntry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = [self compare: e.key with: key];
		if (res == NSOrderedSame) {
			id ret = [e.value retain];
			TMapEntry* ne = [e unlinkNext];
			if (ne == nil) {
				if (e == myRoot) {
					myRoot = e->myLeft;
					myRoot.par = nil;
				} else {
					[e delink];
				}
				[e release];
			} else {
				e.value = ne.value;
				e.key = ne.key;
				[ne release];
			}
			mySize--;
			return [ret autorelease];
		} else if (res == NSOrderedDescending) {
			e = e->myLeft;
		} else {
			e = e->myRight;
		}
	}
	return nil;
}

- (BOOL) containsKey: (id) key {
	TMapEntry* e = myRoot;
	while (e != nil) {
		NSComparisonResult res = [self compare: e.key with: key];
		if (res == NSOrderedSame) return YES;
		if (res == NSOrderedDescending) {
			e = e->myLeft;
		} else {
			e = e->myRight;
		}
	}
	return NO;
}

- (NSObject<JBIterator>*) entryIterator {
	__block NSInteger done = 0;
	__block TMapEntry* e = [self firstEntry],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (e == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
		id ret = e;
		prev = e;
		e = [self nextEntry: e];
		done++;
		return ret;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];
		done--;
	}] autorelease];
}

- (NSObject<JBIterator>*) keyIterator {
	__block NSInteger done = 0;
	__block TMapEntry* e = [self firstEntry],* prev = nil;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (e == nil) {
			@throw [JBAbstractIterator noSuchElement];
		}
		id ret = e.key;
		prev = e;
		e = [self nextEntry: e];
		done++;
		return ret;
	} hasNextCL: ^BOOL(void) {
		return done < mySize;
	} removeCL: ^void(void) {
		if (prev == nil) {
			@throw [JBAbstractIterator badRemove];
		}
		[self remove: prev.key];
		done--;
	}] autorelease];
}

- (void) clear {
	[self clear: myRoot];
	myRoot = nil;
	mySize = 0;
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
	[myComparator release];
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
