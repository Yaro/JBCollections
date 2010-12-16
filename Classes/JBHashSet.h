#import <Foundation/Foundation.h>
#import "JBAbstractCollection.h"
#import "JBSet.h"
#import "JBHashMap.h"

@interface JBHashSet : JBAbstractCollection<JBSet> {
	JBHashMap* myMap;
}

- (id) initWithCapacity: (NSInteger) initCapacity loadFactor: (double) f;
- (id) initWithCapacity: (NSInteger) initCapacity;

@end