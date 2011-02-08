#import <Foundation/Foundation.h>
#import "JBAbstractList.h"

@interface JBArray : JBAbstractList<JBFastEnumerable> {
	id* myArray;
	int mySize;
}

@property (readonly, nonatomic) NSInteger size;

- (id) initWithSize: (NSInteger) n;
+ (JBArray*) withSize: (NSInteger) n;

- (JBArray*) subarray: (NSRange) range;

@end