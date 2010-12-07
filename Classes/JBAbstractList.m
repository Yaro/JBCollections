#import "JBAbstractList.h"

@implementation JBAbstractList

- (id) get: (NSInteger) index {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (NSInteger) indexOf: (id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (id <JBList>) subListInRange: (NSRange) range {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (id) setObject: (id) o atIndex: (NSInteger) index {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (id<JBIterator>) iterator {
	if (![self conformsToProtocol:@protocol(JBRandomAccess)])
		@throw [NSException exceptionWithName:@"no iterator" reason:@"list interface doesn't confirm to JBRandomAccess" userInfo:nil];
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= [self size]) return nil;
		return [self get:cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < [self size];
	}] autorelease];
}

@end


@implementation LRNode 

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item {
	LRNode* ret = [[LRNode alloc] init];
	ret->myItem = item;
	ret->myNextNode = nextNode;
	ret->myPrevNode = prevNode;
	return [ret autorelease];
}

@end