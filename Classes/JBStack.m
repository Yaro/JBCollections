#import "JBStack.h"

@implementation JBStack

- (BOOL) empty {
	return [self isEmpty];
}
- (id) peek {
	return [self getLast];
}
- (id) pop {
	return [self removeLast];
}
- (void) push: (id) o {
	return [self addLast: o];
}

- (NSString*) toString {
	return [NSString stringWithFormat: @"JBStack instance, size = %d", mySize];
}

@end
