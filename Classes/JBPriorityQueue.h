#import "JBAbstractCollection.h"
#import "JBQueue.h"
#import "JBArrays.h"

@interface JBPriorityQueue : JBAbstractCollection <JBQueue> {
	id* myQueue;
	NSUInteger myLength; // allocated array length
	NSComparator myComparator;
	NSUInteger mySize;
}

@property (assign, readonly, nonatomic) NSUInteger size;

- (void) initWithCapacity: (NSInteger) capacity comparator: (NSComparator) comp;

@end