#import "JBIntAbstractList.h"
#import "JBIntArray.h"
#import "JBIntArrayList.h"


@implementation JBIntAbstractList

- (TYPE) get: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (NSInteger) indexOf: (TYPE) o {
	@throw [JBExceptions unsupportedOperation];
}

- (TYPE) set: (TYPE) o at: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}

- (TYPE) removeAt: (NSInteger) index {
	@throw [JBExceptions unsupportedOperation];
}


- (TYPE) first {
	return [self get: 0];
}

- (TYPE) last {
	return [self get: self.size - 1];
}


- (BOOL) contains: (TYPE) o {
	return [self indexOf: o] != NSNotFound;
}

- (BOOL) isEqual: (id) o {
	if (!([o isKindOfClass: [JBIntAbstractList class]])) {
		return NO;
	}
	id ourIter = [self iterator], iter = [o iterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || [ourIter next] != [iter next]) {
			return NO;
		}
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return YES;
}

- (void) reverse {
	JBIntArray* arr = [self toJBIntArray];
	[arr reverse];
	[self clear];
	int size = arr.size;
	for (int i = 0; i < size; i++) {
		[self add: [arr get: i]];
	}
}

- (void) sort {
	JBIntArray* arr = [self toJBIntArray];
	[arr sort];
	[self clear];
	int size = arr.size;
	for (int i = 0; i < size; i++) {
		[self add: [arr get: i]];
	}
}

@end