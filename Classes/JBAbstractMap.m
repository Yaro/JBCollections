#import "JBAbstractMap.h"

@implementation JBAbstractMap


+ (id) withKeysAndObjects: (id) firstKey, ... {
	id ret = [self new];
	id object, key;
	va_list argumentList;
	if (firstKey) {
		va_start(argumentList, firstKey);
		id firstObject = va_arg(argumentList, id);
		if (firstObject == nil) {
			@throw [NSException exceptionWithName: @"odd number of elements" reason: @"" userInfo: nil];
		}
		[ret putKey: firstKey withValue: firstObject];
		while (key = va_arg(argumentList, id)) {
			object = va_arg(argumentList, id);
			if (object == nil) {
				@throw [NSException exceptionWithName: @"odd number of elements" reason: @"" userInfo: nil];
			}
			[ret putKey: key withValue: object];
		}
	}
	return [ret autorelease];
}

+ (id) withMap: (id<JBMap>) map {
	id ret = [self new];
	[ret putAll: map];
	return [ret autorelease];
}

- (NSObject<JBIterator>*) entryIterator {
	@throw [NSException exceptionWithName: @"No entryIterator implementation" reason: @"" userInfo: nil];
}

- (NSObject<JBIterator>*) keyIterator {
	@throw [NSException exceptionWithName: @"No keyIterator implementation" reason: @"" userInfo: nil];
}

- (id) putKey: (id) key withValue: (id) value {
	@throw [JBExceptions unsupportedOperation];
}

- (id) remove: (id) key {
	@throw [JBExceptions unsupportedOperation];
}

- (NSUInteger) size {
	@throw [JBExceptions unsupportedOperation];
}

- (void) clear {
	@throw [JBExceptions unsupportedOperation];
}


- (NSUInteger) hash {
	NSUInteger ret = 0;
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		ret += [[iter next] hash];
	}
	return ret;
}


- (NSString*) description {
	NSMutableString* s = [NSMutableString stringWithFormat: @"%@, size = %d:\n", [self class], self.size];
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		[s appendFormat: @"%@\n", [iter next]];
	}
	return s;
}

- (BOOL) containsKey: (id) key {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
	 JBMapEntry* entry = [iter next];
		if ([entry.key isEqual: key]) {
			return YES;
		}
	}
	return NO;
}

- (BOOL) containsValue: (id) value {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
	 JBMapEntry* entry = [iter next];
		if ([entry.value isEqual: value]) {
			return YES;
		}
	}
	return NO;
}


- (id) get: (id) key {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
	 JBMapEntry* entry = [iter next];
		if ([entry.key isEqual: key]) {
			return entry.value;
		}
	}
	return nil;
}


- (BOOL) isEmpty {
	return self.size == 0;
}

- (void) putAll: (id<JBMap>) map {
	id iter = [map entryIterator];
	while ([iter hasNext]) {
	 JBMapEntry* e = [iter next];
		[self putKey: e.key withValue: e.value];
	}
}

- (JBArray*) values {
	JBArray* arr = [[JBArray alloc] initWithSize: self.size];
	int cnt = 0;
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		JBMapEntry* e = [iter next];
		[arr set: e.value at: cnt++];
	}
	return [arr autorelease];
}

- (id) copyWithZone: (NSZone*) zone {
	return [[[self class] withMap: self] retain];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	static id iter;
	
	if (state->state == 0) {
		iter = [[self keyIterator] retain];
		state->mutationsPtr = &(state->extra[0]);
		state->state = 1;
	}
	state->itemsPtr = stackbuf;
	
	for (int i = 0; i < len; i++) {
		if (![iter hasNext]) {
			if (i == 0) {
				[iter release];
			}
			return i;
		}
		stackbuf[i] = [iter next];
	}
	
	return len;
}

@end