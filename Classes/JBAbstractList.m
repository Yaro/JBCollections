#import "JBAbstractList.h"
#import "JBArray.h"
#import "JBArrayList.h"
#import "JBCollections.h"

@interface JBSublist : JBAbstractList {
	NSInteger myOffset, mySize;
	JBAbstractList* myList;
}

- (id) initWithList: (JBAbstractList*) list range: (NSRange) range;

@end




@implementation JBAbstractList

- (id) get: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (NSInteger) indexOf: (id) o {
	@throw [JBExceptions unsupportedOperation];
}

- (id) set: (id) o at: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (id) removeAt: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}


- (id) first {
	return [self get: 0];
}

- (id) last {
	return [self get: self.size - 1];
}

- (id <JBList>) sublist: (NSRange) range {
	return [[[JBSublist alloc] initWithList: self range: range] autorelease];
}

- (BOOL) contains: (id) o {
	return [self indexOf: o] != NSNotFound;
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractList class]])) {
		return NO;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || !equals([ourIter next], [iter next])) {
			return NO;
		}
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return YES;
}

- (void) reverse {
	JBArray* arr = [self toJBArray];
	[arr reverse];
	[self clear];
	int size = arr.size;
	for (int i = 0; i < size; i++) {
		[self add: [arr get: i]];
	}
}

- (void) sort: (NSComparator) cmp {
	JBArray* arr = [self toJBArray];
	[arr sort: cmp];
	[self clear];
	int size = arr.size;
	for (int i = 0; i < size; i++) {
		[self add: [arr get: i]];
	}
}

@end




@implementation JBSublist {

}

- (id) initWithList: (JBAbstractList*) plist range: (NSRange) range {
	[super init];
	if (range.location < 0 || range.location + range.length > plist.size) {
		@throw [NSException exceptionWithName: @"bad sublist range" reason: @"" userInfo: nil];
	}
	myList = [plist retain];
	myOffset = range.location;
	mySize = range.length;
	return self;
}

- (id) get: (NSInteger) index {
	if (index < 0 || index >= mySize) {
		@throw [JBExceptions indexOutOfBounds: index size: mySize];
	}
	return [myList get: index + myOffset];
}

- (id) set: (id) o at: (NSInteger) index {
	if (index < 0 || index >= mySize) {
		@throw [JBExceptions indexOutOfBounds: index size: mySize];
	}
	return [myList set: o at: index + myOffset];
}

- (NSUInteger) size {
	return mySize;
}

- (void) dealloc {
	[myList release];
	[super dealloc];
}

@end