#import "JBAbstractMap.h"
#import "JBArrays.h"
@class HMapEntry;

@interface JBHashMap : JBAbstractMap {
@public
	HMapEntry** myTable;
	NSInteger mySize, myLength, myThreshold;
	double myLoadFactor;
}

@property (readonly) NSInteger size;
@property (readonly) double loadFactor;

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f;
- (id) initWithCapacity: (NSInteger) initCapacity;

@end