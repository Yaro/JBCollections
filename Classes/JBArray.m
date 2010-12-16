#import "JBArray.h"
#import "JBArrays.h"

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

- (id) initWithSize: (NSInteger) n {
	[super init];
	myLength = n;
	//NSLog(@"creating array with length = %d", myLength);
	myArray = arrayWithLength(n);
	//myArray = malloc(myLength * sizeof(id));
	//memset(myArray, 0, myLength * sizeof(id));
	//NSLog(@"pointer size = %d", sizeof(myArray)); --- equals 4, certainly
	return self;
}

- (id) init {
	return [self initWithSize: 0];
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

+ (JBArray*) createWithObjects: (id) firstObject, ... {
	id object;
	va_list argumentList;
	int size = 0;
	if (firstObject) {
		size++;
		va_start(argumentList, firstObject);
		while (va_arg(argumentList, id))
			size++;
		va_end(argumentList);
	}
	JBArray* ret = [[JBArray createWithSize: size] retain];
	
	int index = 0;
	if (firstObject) {
		ret->myArray[index++] = [firstObject retain];
		va_start(argumentList, firstObject);
		while (object = va_arg(argumentList, id))
			ret->myArray[index++] = [object retain];
	}
	return [ret autorelease];
}

- (void) dealloc {
	for (int i = 0; i < myLength; i++)
		[myArray[i] release];
	free(myArray);
	[super dealloc];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	if (state->state == 0) {
		// initialization
		state->mutationsPtr = &(state->extra[0]);
	}
	NSInteger i = 0;
	state->itemsPtr = stackbuf;
	for (i = 0; i < len; i++) {
		if (state->state >= myLength) return i;
		stackbuf[i] = myArray[state->state++];
	}
	return i;
}

- (id*) toArray {
	return copyOf(myArray, myLength);
}

- (NSUInteger) size {
	return myLength;
}

@end



