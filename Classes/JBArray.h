#import <Foundation/Foundation.h>
#import "JBAbstractList.h"

@interface JBArray : JBAbstractList {
	id* myArray;
	int myLength;
}

@property (readonly, nonatomic) NSInteger length;

- (id) initWithSize: (NSInteger) n;
- (id) set: (id) object at: (NSInteger) i;
- (id) get: (NSInteger) i;
- (void) sort: (NSComparator) cmp;
- (void) reverse;

+ (JBArray*) withSize: (NSInteger) n;
+ (JBArray*) withObjects: (id) firstObject, ...;

- (JBArray*) subarray: (NSRange) range;

@end