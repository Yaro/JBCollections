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

- (void) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp;

@end