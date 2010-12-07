#import "JBAbstractIterator.h"


@implementation JBAbstractIterator

- (id) initWithNextCL: (id(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 {
	[super init];
	nextCL = handler1;
	hasNextCL = handler2;
	return self;
}

- (id) next {
	return nextCL();
}

- (BOOL) hasNext {
	return hasNextCL();
}

@end
