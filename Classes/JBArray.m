#import "JBArray.h"

/*

// just another way to hide a method
 
@interface JBArray()
- (void) rangeCheck: (NSInteger) n;
@end
 
 */

inline static void rangeCheck(JBArray* arr, NSInteger i) {
	if (i < 0 || i >= arr.length)
		@throw [NSException exceptionWithName:@"JBArray index out of bounds" 
									   reason:[NSString stringWithFormat:@"Index: %d Size: %d", i, arr.length] userInfo:nil];
}

@implementation JBArray

@synthesize length = myLength;

- (id) initWithSize:(NSInteger)n {
	[super init];
	myLength = n;
	NSLog(@"creating array with length = %d", myLength);
	myArray = malloc(myLength * sizeof(id));
	memset(myArray, 0, myLength * sizeof(id));
	return self;
}

- (id) init {
	return [self initWithSize:0];
}

- (void) set: (id) object atIndex: (NSInteger) i {
	rangeCheck(self, i);
	[object retain];
	//NSLog(@"address = %d", [self get:i]);
	[myArray[i] release];
	myArray[i] = object;
}

- (id) get: (NSInteger) i {
	rangeCheck(self, i);
	return myArray[i];
}

+ (JBArray*) createWithSize: (NSInteger) n {
	JBArray* ret = [[JBArray alloc] initWithSize: n];
	return [ret autorelease];
}

- (void) dealloc {
	for (int i = 0; i < myLength; i++)
		[myArray[i] release];
	free(myArray);
	[super dealloc];
}

@end



