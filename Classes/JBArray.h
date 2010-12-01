#import <Foundation/Foundation.h>


@interface JBArray : NSObject {
	id* myArray;
	int myLength;
}

@property (readonly, assign, nonatomic) NSInteger myLength;

- (id) initWithSize: (NSInteger) n;
- (void) set: (id) object atIntex: (NSInteger) i;
- (id) get: (NSInteger) i;

@end