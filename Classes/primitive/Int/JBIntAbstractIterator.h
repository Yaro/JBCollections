#import <Foundation/Foundation.h>
#import "JBIntIterator.h"

@interface JBIntAbstractIterator : NSObject<JBIntIterator> {	
	BOOL (^hasNextCL) (void);
	TYPE (^nextCL) (void);
	void (^removeCL) (void);
}

- (id) initWithNextCL: (TYPE(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2;
- (id) initWithNextCL: (TYPE(^)(void)) handler1 hasNextCL: (BOOL(^)(void)) handler2 removeCL: (void(^)(void)) handler3;

+ (NSException*) noSuchElement;
+ (NSException*) noRemove;
+ (NSException*) badRemove;

@end
