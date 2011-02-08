#import <Foundation/Foundation.h>
#import "JBIntAbstractList.h"

@interface JBIntArray : JBIntAbstractList {
	TYPE* myArray;
	NSInteger mySize;
}

@property (readonly, nonatomic) NSInteger size;

- (id) initWithSize: (NSInteger) n;
+ (JBIntArray*) withSize: (NSInteger) n;

- (JBIntArray*) subarray: (NSRange) range;

@end