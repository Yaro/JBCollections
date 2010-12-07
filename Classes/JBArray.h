#import <Foundation/Foundation.h>


@interface JBArray : NSObject <NSFastEnumeration> {
	id* myArray;
	int myLength;
}

@property (readonly, assign, nonatomic) NSInteger length;

- (id) initWithSize: (NSInteger) n;
- (void) set: (id) object atIndex: (NSInteger) i;
- (id) get: (NSInteger) i;
+ (JBArray*) createWithSize: (NSInteger) n;

@end