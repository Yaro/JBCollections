#import <Foundation/Foundation.h>
#import "JBAbstractList.h"

@interface JBArrayList : JBAbstractList {
	NSInteger mySize, myLength;
	id* myData;
}

@property (readonly) NSInteger size;

+ (id) withCapacity: (NSInteger) n;
- (id) initWithCapacity: (NSInteger) n;

- (void) insert: (id) o at: (NSInteger) index;
- (JBArrayList*) subarray: (NSRange) range;

@end
