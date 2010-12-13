#import <Foundation/Foundation.h>
#import "JBAbstractList.h"

@interface JBArray : JBAbstractList <NSFastEnumeration, JBRandomAccess> {
	id* myArray;
	int myLength;
}

@property (readonly, nonatomic) NSInteger length;

- (id) initWithSize: (NSInteger) n;
- (void) set: (id) object atIndex: (NSInteger) i;
- (id) get: (NSInteger) i;
+ (JBArray*) createWithSize: (NSInteger) n;
+ (JBArray*) createWithObjects: (id) firstObject, ...;

@end