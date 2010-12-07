#import "JBIterator.h"

@interface JBAbstractIterator : NSObject<JBIterator> {	
	BOOL (^hasNextCL) (void);
	id (^nextCL) (void);
}

- (id) initWithNextCL: (id(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2;

@end
