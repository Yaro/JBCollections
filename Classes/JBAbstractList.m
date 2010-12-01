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

@end
