#import <Foundation/Foundation.h>
#import "JBAbstractCollection.h"
#import "JBQueue.h"
#import "JBArrays.h"
#import "JBComparatorRequired.h"

@interface JBPriorityQueue : JBAbstractCollection<JBQueue, JBComparatorRequired> {
	id* myQueue;
	NSUInteger myLength;
	NSComparator myComparator;
	NSUInteger mySize;
}

@property (readonly) NSUInteger size;
@property (readonly) NSComparator comparator;

- (id) initWithComparator: (NSComparator) comp;
- (id) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp;

+ (id) withCapacity: (NSInteger) capacity comparator: (NSComparator) comp;
+ (id) withComparator: (NSComparator) comp;

@end