#import "JBAbstractList.h"
#import "JBArray.h"

@interface JBSublist : JBAbstractList {
	NSInteger myOffset, myLength;
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



- (id <JBList>) sublist: (NSRange) range {
	return [[[JBSublist alloc] initWithList: self range: range] autorelease];
}

- (BOOL) contains: (id) o {
	return [self indexOf: o] >= 0;
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractList class]])) {
		return NO;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || ![[ourIter next] isEqual: [iter next]]) {
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
	for (int i = 0; i < arr.size; i++) {
		[self add: [arr get: i]];
	}
}

- (void) sort: (NSComparator) cmp {
	JBArray* arr = [self toJBArray];
	[arr sort: cmp];
	[self clear];
	for (int i = 0; i < arr.size; i++) {
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
	myLength = range.length;
	return self;
}

- (id) get: (NSInteger) index {
	if (index < 0 || index >= myLength) {
		@throw [JBExceptions indexOutOfBounds: index size: myLength];
	}
	return [myList get: index + myOffset];
}

- (id) set: (id) o at: (NSInteger) index {
	if (index < 0 || index >= myLength) {
		@throw [JBExceptions indexOutOfBounds: index size: myLength];
	}
	return [myList set: o at: index + myOffset];
}

- (NSUInteger) size {
	return myLength;
}

- (void) dealloc {
	[myList release];
	[super dealloc];
}

@end