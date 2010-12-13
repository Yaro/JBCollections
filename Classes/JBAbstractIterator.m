#import "JBAbstractIterator.h"


@implementation JBAbstractIterator

- (id) initWithNextCL: (id(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 {
	[super init];
	nextCL = [handler1 copy];
	hasNextCL = [handler2 copy];
	return self;
}

- (id) next {
	return nextCL();
}

- (BOOL) hasNext {
	return hasNextCL();
}

- (void) dealloc {
	[nextCL release];
	[hasNextCL release];
	[super dealloc];
}

@end
