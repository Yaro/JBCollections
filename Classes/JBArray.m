#import "JBArray.h"
#import "JBArrays.h"

/*

// just another way to hide a method
 
@interface JBArray()
- (void) rangeCheck: (NSInteger) n;
@end
 
 */

inline static void rangeCheck(JBArray* arr, NSInteger i) {
	if (i < 0 || i >= arr.length) {
		@throw [NSException exceptionWithName: @"JBArray index out of bounds" 
			reason: [NSString stringWithFormat: @"Index: %d Size: %d", i, arr.length] userInfo: nil];
	}
}

@implementation JBArray

@synthesize length = myLength;

- (id) initWithSize: (NSInteger) n {
	[super init];
	myLength = n;
	myArray = arrayWithLength(n);
	return self;
}

- (id) init {
	return [self initWithSize: 0];
}

- (id) set: (id) object at: (NSInteger) i {
	rangeCheck(self, i);
	id ret = myArray[i];
	myArray[i] = [object retain];
	return [ret autorelease];
}

- (id) get: (NSInteger) i {
	rangeCheck(self, i);
	return myArray[i];
}

- (id) removeAt: (NSInteger) index {
	return [self set: nil at: index];
}

+ (JBArray*) withSize: (NSInteger) n {
	JBArray* ret = [[JBArray alloc] initWithSize: n];
	return [ret autorelease];
}

+ (JBArray*) withObjects: (id) firstObject, ... {
	id object;
	va_list argumentList;
	int size = 0;
	if (firstObject) {
		size++;
		va_start(argumentList, firstObject);
		while (va_arg(argumentList, id)) {
			size++;
		}
		va_end(argumentList);
	}
	JBArray* ret = [[JBArray withSize: size] retain];
	
	int index = 0;
	if (firstObject) {
		ret->myArray[index++] = [firstObject retain];
		va_start(argumentList, firstObject);
		while (object = va_arg(argumentList, id)) {
			ret->myArray[index++] = [object retain];
		}
	}
	return [ret autorelease];
}

- (void) dealloc {
	for (int i = 0; i < myLength; i++) {
		[myArray[i] release];
	}
	deleteArray(myArray);
	[super dealloc];
}

- (NSObject<JBIterator>*) iterator {
	__block NSInteger cursor = 0;
	return [[[JBAbstractIterator alloc] initWithNextCL: ^id(void) {
		if (cursor >= myLength) {
			@throw [JBAbstractIterator noSuchElement];
		}
		return myArray[cursor++];
	} hasNextCL: ^BOOL(void) {
		return cursor < myLength;
	} removeCL: ^void(void) {
		if (cursor > 0) {
			[self removeAt: cursor - 1];
		} else {
			@throw [JBAbstractIterator badRemove];
		}
	}] autorelease];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	if (state->state == 0) {
		state->mutationsPtr = &(state->extra[0]);
	}
	NSInteger i = 0;
	state->itemsPtr = stackbuf;
	for (i = 0; i < len; i++) {
		if (state->state >= myLength) {
			return i;
		}
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



