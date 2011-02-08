#import <Foundation/Foundation.h>
#import "JBIntAbstractList.h"


@interface JBIntArrayList : JBIntAbstractList {
	NSInteger mySize, myLength;
	TYPE* myData;
}

@property (readonly) NSInteger size;

+ (id) withCapacity: (NSInteger) n;
- (id) initWithCapacity: (NSInteger) n;

- (void) insert: (TYPE) o at: (NSInteger) index;
- (JBIntArrayList*) subarray: (NSRange) range;

@end
