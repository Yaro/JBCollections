#import "JBStack.h"

@implementation JBStack

- (BOOL) empty {
	return [self isEmpty];
}
- (id) peek {
	return [self last];
}
- (id) pop {
	return [self removeLast];
}
- (void) push: (id) o {
	return [self addLast: o];
}

@end
