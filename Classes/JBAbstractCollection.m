#import "JBAbstractCollection.h"
#import "JBArray.h"
#import "JBArrays.h"

@implementation JBAbstractCollection

- (NSString*) toString {
	return [NSString stringWithString:@"abstract collection toString method"];
}

- (BOOL) contains: (id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) add: (NSObject*) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) addAll: (id <JBCollection>) c {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (void) clear {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) containsAll: (id <JBCollection>) c {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) isEqual: (id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (NSUInteger) hash {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) isEmpty {
	return [self size] != 0;
}
- (BOOL) remove:(id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (BOOL) removeAll: (id <JBCollection>) c {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}
- (NSUInteger) size {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (id<JBIterator>) iterator {
	@throw [NSException exceptionWithName:@"No iterator in collection" reason:@"" userInfo:nil];
}

- (void) dealloc {
	[self clear];
	[super dealloc];
}

- (BOOL) hasNext {
	@throw [NSException exceptionWithName:@"No iterator implementation in collection" reason:@"" userInfo:nil];
}

- (id) next {
	@throw [NSException exceptionWithName:@"No iterator implementation in collection" reason:@"" userInfo:nil];
}

- (id*) toArray {
	int size = [self size];
	id* arr = malloc(sizeof(id) * size);
	id<JBIterator> iter = [self iterator];
	// -retain not found in protocol...
	[iter retain];
	for (int i = 0; i < size; i++)
		arr[i] = [iter next];
	[iter release];
	return arr;
}

- (JBArray*) toJBArray {
	JBArray* arr = [[JBArray createWithSize: [self size]] retain];
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < [self size]; i++) {
		[arr set:[iter next] atIndex:i];
	}
	return [arr autorelease];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger)len {
	if (state->state == 0) {
		state->itemsPtr = [self toArray];
		state->mutationsPtr = &(state->extra[0]);
		state->state = 1;
	}
	NSInteger cLen = [self size], index = state->state - 1, i = 0;
	for (i = 0; i < len; i++) {
		if (index >= cLen) {
			deleteArray(state->itemsPtr);
			return i;
		}
		stackbuf[i] = state->itemsPtr[index++];
	}
	state->state += i;
	return i;
}

@end
