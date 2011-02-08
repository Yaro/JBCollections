#import "JBIntAbstractIterator.h"


@implementation JBIntAbstractIterator

- (id) initWithNextCL: (TYPE(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 removeCL: (void(^)(void)) handler3 {
	[super init];
	nextCL = [handler1 copy];
	hasNextCL = [handler2 copy];
	removeCL = [handler3 copy];
	return self;
}

- (id) initWithNextCL: (TYPE(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 {
	return [self initWithNextCL: handler1 hasNextCL: handler2 removeCL: nil];
}

- (TYPE) next {
	return nextCL();
}

- (BOOL) hasNext {
	return hasNextCL();
}

- (void) remove {
	if (removeCL == nil) {
		@throw [JBIntAbstractIterator noRemove];
	} 
	removeCL();
}

- (void) dealloc {
	[nextCL release];
	[hasNextCL release];
	[removeCL release];
	[super dealloc];
}

+ (NSException*) noSuchElement {
	return [NSException exceptionWithName: @"No such element exception" reason: @"end reached while iterating" userInfo: nil];
}

+ (NSException*) noRemove {
	return [NSException exceptionWithName: @"No remove supported by iterator" reason: @"" userInfo: nil];
}

+ (NSException*) badRemove {
	return [NSException exceptionWithName: @"Remove execution before next" reason: @"Nothing to remove" userInfo: nil];
}

@end