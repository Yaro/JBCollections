#import "JBAbstractList.h"


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

- (id <JBList>) sublist: (NSRange) range {
	return [[[JBSublist alloc] initWithList: self range: range] autorelease];
}

- (id) set: (id) o at: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (id) removeAt: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (BOOL) contains: (id) o {
	return [self indexOf: o] >= 0;
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBAbstractList class]])) {
		return FALSE;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || ![[ourIter next] isEqual: [iter next]]) {
			return FALSE;
		}
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return TRUE;
}

- (NSObject<JBIterator>*) iterator {
	@throw [NSException exceptionWithName: @"no iterator" reason: @"this list doesn't provide iterator" userInfo: nil];
}

@end




@implementation JBSublist {

}

- (id) initWithList: (JBAbstractList*) plist range: (NSRange) range {
	[super init];
	if (range.location < 0 || range.location + range.length > [plist size]) {
		@throw [NSException exceptionWithName: @"bad sublist range" reason: @"" userInfo: nil];
	}
	myList = [plist retain];
	myOffset = range.location;
	myLength = range.length;
	return self;
}

- (id) get: (NSInteger) index {
	if (index < 0 || index >= myLength) {
		@throw [JBExceptions indexOutOfBounds];
	}
	return [myList get: index + myOffset];
}

- (id) set: (id) o at: (NSInteger) index {
	if (index < 0 || index >= myLength) {
		@throw [JBExceptions indexOutOfBounds];
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