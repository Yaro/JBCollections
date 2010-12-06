@interface PriorityQueue : NSObject {
	NSComparator myComparator;
	NSUInteger mySize;
	id* myQueue;
}

@property (assign, readonly, nonatomic) NSUInteger size;

@end
