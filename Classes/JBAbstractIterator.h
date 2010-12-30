#import "JBIterator.h"

@interface JBAbstractIterator : NSObject<JBIterator> {	
	BOOL (^hasNextCL) (void);
	id (^nextCL) (void);
	void (^removeCL) (void);
}

- (id) initWithNextCL: (id(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2;
- (id) initWithNextCL: (id(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 removeCL: (void(^)(void)) handler3;

+ (NSException*) noSuchElement;
+ (NSException*) noRemove;
+ (NSException*) badRemove;

@end
