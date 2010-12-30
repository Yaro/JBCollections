#import <Foundation/Foundation.h>
#import "JBAbstractList.h"

@interface JBArray : JBAbstractList<NSFastEnumeration> {
	id* myArray;
	int myLength;
}

@property (readonly, nonatomic) NSInteger length;

- (id) initWithSize: (NSInteger) n;
- (id) set: (id) object at: (NSInteger) i;
- (id) get: (NSInteger) i;
+ (JBArray*) withSize: (NSInteger) n;
+ (JBArray*) withObjects: (id) firstObject, ...;

@end