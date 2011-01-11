#import "JBAbstractCollection.h"
#import "JBQueue.h"
#import "JBArrays.h"

@interface JBPriorityQueue : JBAbstractCollection<JBQueue> {
	id* myQueue;
	NSUInteger myLength;
	NSComparator myComparator;
	NSUInteger mySize;
}

@property (readonly) NSUInteger size;
@property (readonly) NSComparator comparator;

- (id) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp;
- (id) initWithComparator: (NSComparator) comp;

+ (id) withComparator: (NSComparator) comp;

@end