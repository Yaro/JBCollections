#import <Foundation/Foundation.h>
#import "JBAbstractList.h"
#import "JBRandomAccess.h"

@interface JBArrayList : JBAbstractList <JBRandomAccess> {
	NSInteger mySize, myLength;
	id* myData;
}

@property (readonly) NSInteger size;

- (id) initWithCapacity: (NSInteger) n;
- (id) initWithCollection: (id<JBCollection>) c;
- (void) insert: (id) o atIndex: (NSInteger) index;

@end
