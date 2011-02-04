#import <Foundation/Foundation.h>
#import "JBAbstractMap.h"
#import "JBArrays.h"
@class HMapEntry;

@interface JBHashMap : JBAbstractMap {
	HMapEntry** myTable;
	NSUInteger mySize, myLength, myThreshold;
	double myLoadFactor;
}

@property (readonly) NSUInteger size;
@property (readonly) double loadFactor;

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f;
- (id) initWithCapacity: (NSInteger) initCapacity;
- (id) init;

- (BOOL) isEqual: (id) o;

@end