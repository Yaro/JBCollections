#import "JBAbstractCollection.h"
#import "JBArray.h"
#import "JBArrays.h"
#import "JBArrayList.h"

@implementation JBAbstractCollection


+ (id) withCollection: (id<JBCollection>) c {
	id ret = [self new];
	[ret addAll: c];
	return [ret autorelease];
}

+ (id) withObjects: (id) firstObject, ... {
	id ret = [self new];
	id object;
	va_list argumentList;
	if (firstObject) {
		va_start(argumentList, firstObject);
		[ret add: firstObject];
		while (object = va_arg(argumentList, id)) {
			[ret add: object];
		}
	}
	return [ret autorelease];
}

- (NSObject<JBIterator>*) iterator {
	@throw [JBExceptions noIterator];
}

- (BOOL) remove: (id) o {
	@throw [JBExceptions unsupportedOperation];
}

- (NSUInteger) size {
	@throw [JBExceptions unsupportedOperation];
}

- (BOOL) contains: (id) o {
	@throw [JBExceptions unsupportedOperation];
}

- (BOOL) add: (NSObject*) o {
	@throw [JBExceptions unsupportedOperation];
}

- (void) clear {
	@throw [JBExceptions unsupportedOperation];
}

- (id) copyWithZone: (NSZone*) zone {
	return [[[self class] withCollection: self] retain];
}

- (NSString*) description {
	NSMutableString* s = [NSMutableString stringWithFormat: @"%@, size = %d:\n", [[self class] description], self.size];
	id iter = [self iterator];
	while ([iter hasNext]) {
		[s appendFormat: @"element: %@\n", [[iter next] description]];
	}
	return s;
}


- (BOOL) addAll: (id<JBCollection>) c {
	id iter = [c iterator];
	BOOL anyAdded = NO;
	while ([iter hasNext]) {
		anyAdded |= [self add: [iter next]];
	}
	return anyAdded;
}

- (BOOL) containsAll: (id<JBCollection>) c {
	id iter = [c iterator];
	while ([iter hasNext]) {
		if (![self contains: [iter next]]) {
			return NO;
		}
	}
	return YES;
}

- (NSUInteger) hash {
	NSUInteger ret = 0;
	id iter = [self iterator];
	while ([iter hasNext]) {
		ret += [[iter next] hash];
	}
	return ret;
}

- (BOOL) isEmpty {
	return self.size == 0;
}

- (BOOL) removeAll: (id <JBCollection>) c {
	id iter = [c iterator];
	BOOL anyRemoved = NO;
	while ([iter hasNext]) {
		anyRemoved |= [self remove: [iter next]];
	}
	return anyRemoved;
}

- (id*) toArray {
	int size = self.size;
	id* arr = malloc(sizeof(id) * size);
	id iter = [self iterator];
	for (int i = 0; i < size; i++) {
		arr[i] = [iter next];
	}
	return arr;
}

- (JBArray*) toJBArray {
	JBArray* arr = [JBArray withSize: self.size];
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < self.size; i++) {
		[arr set: [iter next] at: i];
	}
	return arr;
}

- (NSMutableArray*) toNSArray {
	NSMutableArray* arr = [NSMutableArray arrayWithCapacity: self.size];
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < self.size; i++) {
		[arr addObject: [iter next]];
	}
	return arr;
}

- (BOOL) any: (BOOL(^)(id)) handler {
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < self.size; i++) {
		if (handler([iter next]) == YES) {
			return YES;
		}
	}
	return NO;
}

- (BOOL) all: (BOOL(^)(id)) handler {
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < self.size; i++) {
		if (handler([iter next]) == NO) {
			return NO;
		}
	}
	return YES;
}


- (JBArrayList*) select: (BOOL(^)(id)) handler {
	JBArrayList* ret = [JBArrayList new];
	id<JBIterator> iter = [self iterator];
	for (int i = 0; i < self.size; i++) {
		id item = [iter next];
		if (handler(item) == YES) {
			[ret add: item];
		}
	}
	return [ret autorelease];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	static id iter;
	
	if (state->state == 0) {
		iter = [self iterator];
		[iter retain];
		state->mutationsPtr = &(state->extra[0]);
		state->state = 1;
	}
	state->itemsPtr = stackbuf;
	
	int i;
	for (i = 0; i < len; i++) {
		if (![iter hasNext]) {
			if (i == 0) {
				[iter release];
			}
			return i;
		}
		stackbuf[i] = [iter next];
	}
	
	return i;
}

@end
