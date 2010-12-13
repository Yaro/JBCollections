#import "JBAbstractCollection.h"
#import "JBArray.h"
#import "JBArrays.h"

@implementation JBAbstractCollection


- (id<JBIterator>) iterator {
	@throw [NSException exceptionWithName:@"No iterator in collection" reason:@"" userInfo:nil];
}

- (BOOL) remove:(id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (NSUInteger) size {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (BOOL) contains: (id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (BOOL) add: (NSObject*) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (void) clear {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (BOOL) isEqual: (id) o {
	@throw [NSException exceptionWithName:@"Unsupported operation exception" reason:@"" userInfo:nil];
}

- (NSString*) toString {
	NSMutableString* s = [[NSMutableString stringWithFormat:@"%@, size = %d:\n", [[self class] description], [self size]] retain];
	id iter = [[self iterator] retain];
	while ([iter hasNext]) {
		[s appendFormat:@"element: %@\n", [[iter next] description]];
	}
	[iter release];
	return [s autorelease];
}


- (BOOL) addAll: (id <JBCollection>) c {
	id iter = [[c iterator] retain];
	BOOL anyAdded = FALSE;
	while ([iter hasNext])
		anyAdded |= [self add: [iter next]];
	[iter release];
	return anyAdded;
}

- (BOOL) containsAll: (id <JBCollection>) c {
	id iter = [[c iterator] retain];
	while ([iter hasNext]) {
		if (![self contains: [iter next]]) {
			[iter release];
			return FALSE;
		}
	}
	[iter release];
	return TRUE;
}

- (NSUInteger) hash {
	NSUInteger ret = 0;
	id iter = [[self iterator] retain];
	while ([iter hasNext])
		ret += [[iter next] hash];
	[iter release];
	return ret;
}
- (BOOL) isEmpty {
	return [self size] != 0;
}

- (BOOL) removeAll: (id <JBCollection>) c {
	id iter = [[c iterator] retain];
	BOOL anyRemoved = FALSE;
	while ([iter hasNext])
		anyRemoved |= [self remove: [iter next]];
	[iter release];
	return anyRemoved;
}

- (id*) toArray {
	int size = [self size];
	id* arr = malloc(sizeof(id) * size);
	id iter = [self iterator];
	// id<JBIterator> => -retain not found in protocol, so NSObject<JBIterator>* or id
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


//toArray version of <NSFastEnumeration> implementation

/*- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger)len {
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
}*/


// iterator version

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	static id iter;
	
	if (state->state == 0) {
		iter = [self iterator];
		[iter retain];
		state->mutationsPtr = &(state->extra[0]);
		state-> state = 1;
	}
	state->itemsPtr = stackbuf;
	
	int i;
	for (i = 0; i < len; i++) {
		if (![iter hasNext]) {
			if (i == 0) [iter release];
			return i;
		}
		stackbuf[i] = [iter next];
	}
	
	return i;
}

@end
