#import "JBIntAbstractCollection.h"
#import "JBIntArray.h"
#import "JBIntArrayList.h"
#import "JBArray.h"

@implementation JBIntAbstractCollection


+ (id) withCollection: (id<JBIntCollection>) c {
	id ret = [self new];
	[ret addAll: c];
	return [ret autorelease];
}

- (NSObject<JBIntIterator>*) iterator {
	@throw [JBExceptions noIterator];
}

- (BOOL) remove: (TYPE) o {
	@throw [JBExceptions unsupportedOperation];
}

- (NSUInteger) size {
	@throw [JBExceptions unsupportedOperation];
}

- (BOOL) contains: (TYPE) o {
	@throw [JBExceptions unsupportedOperation];
}

- (BOOL) add: (TYPE) o {
	@throw [JBExceptions unsupportedOperation];
}

- (void) clear {
	@throw [JBExceptions unsupportedOperation];
}

- (id) copyWithZone: (NSZone*) zone {
	return [[[self class] withCollection: self] retain];
}

- (NSString*) description {
	NSMutableString* s = [NSMutableString stringWithFormat: @"%@, size = %d:\n", [self class], self.size];
	id iter = [self iterator];
	while ([iter hasNext]) {
		[s appendFormat: @"element: %@\n", [iter next]];
	}
	return s;
}


- (BOOL) addAll: (id<JBIntCollection>) c {
	id iter = [c iterator];
	BOOL anyAdded = NO;
	while ([iter hasNext]) {
		anyAdded |= [self add: [iter next]];
	}
	return anyAdded;
}

- (BOOL) containsAll: (id<JBIntCollection>) c {
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
		ret += hash([iter next]);
	}
	return ret;
}

- (BOOL) isEmpty {
	return self.size == 0;
}

- (BOOL) removeAll: (id <JBIntCollection>) c {
	id iter = [c iterator];
	BOOL anyRemoved = NO;
	while ([iter hasNext]) {
		anyRemoved |= [self remove: [iter next]];
	}
	return anyRemoved;
}

- (JBIntArray*) toJBIntArray {
	int size = self.size;
	JBIntArray* arr = [JBIntArray withSize: size];
	id<JBIntIterator> iter = [self iterator];
	for (int i = 0; i < size; i++) {
		[arr set: [iter next] at: i];
	}
	return arr;
}


- (JBArray*) toJBArray {
	int size = self.size;
	JBArray* arr = [JBArray withSize: size];
	id<JBIntIterator> iter = [self iterator];
	for (int i = 0; i < size; i++) {
		[arr set: [NSNumber numberWithInt: [iter next]] at: i];
	}
	return arr;
}

- (BOOL) any: (BOOL(^)(TYPE)) handler {
	id<JBIntIterator> iter = [self iterator];
	int size = self.size;
	for (int i = 0; i < size; i++) {
		if (handler([iter next]) == YES) {
			return YES;
		}
	}
	return NO;
}

- (BOOL) all: (BOOL(^)(TYPE)) handler {
	id<JBIntIterator> iter = [self iterator];
	int size = self.size;
	for (int i = 0; i < size; i++) {
		if (handler([iter next]) == NO) {
			return NO;
		}
	}
	return YES;
}


- (JBIntArrayList*) select: (BOOL(^)(TYPE)) handler {
	JBIntArrayList* ret = [JBIntArrayList new];
	id<JBIntIterator> iter = [self iterator];
	int size = self.size;
	for (int i = 0; i < size; i++) {
		TYPE item = [iter next];
		if (handler(item) == YES) {
			[ret add: item];
		}
	}
	return [ret autorelease];
}

@end
