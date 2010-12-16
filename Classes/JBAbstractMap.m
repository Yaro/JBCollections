#import "JBAbstractMap.h"


@implementation MapEntry

@synthesize key = myKey, value = myValue;

- (NSUInteger) hash {
	return [myKey hash] + [myValue hash];
}

- (BOOL) isEqual: (id) o {
	return ([o class] == [self class] && [[o key] isEqual: myKey] && [[o value] isEqual: myValue]);
}

- (id) initWithKey: (id) key value: (id) value {
	[super init];
	myKey = [key retain];
	myValue = [value retain];
	return self;
}

- (NSString*) description {
	return [NSString stringWithFormat: @"Map entry: KEY = %@, VALUE = %@", myKey, myValue];
}

@end

@implementation JBAbstractMap


- (id) initWithKeysAndObjects: (id) firstKey, ... {
	[self init];
	id object, key;
	va_list argumentList;
	if (firstKey) {
		va_start(argumentList, firstKey);
		id firstObject = va_arg(argumentList, id);
		if (firstObject == nil)
			@throw [NSException exceptionWithName: @"odd number of elements" reason: @"" userInfo: nil];
		[self putKey: firstKey withValue: firstObject];
		while (key = va_arg(argumentList, id)) {
			object = va_arg(argumentList, id);
			if (object == nil)
				@throw [NSException exceptionWithName: @"odd number of elements" reason: @"" userInfo: nil];
			[self putKey: key withValue: object];
		}
	}
	return self;
}

- (id) initWithMap: (id<JBMap>) map {
	//may be dangerous, depends on init
	[self init];
	[self putAll: map];
	return self;
}

- (NSObject<JBIterator>*) entryIterator {
	@throw [NSException exceptionWithName: @"No entryIterator implementation" reason: @"" userInfo:nil];
}

- (NSObject<JBIterator>*) keyIterator {
	@throw [NSException exceptionWithName: @"No keyIterator implementation" reason: @"" userInfo:nil];
}

- (id) putKey: (id) key withValue: (id) value {
	@throw [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo:nil];
}

// returns value associated with the key
- (id) remove: (id) key {
	@throw [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo:nil];
}

- (NSUInteger) size {
	@throw [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo:nil];
}

- (void) clear {
	@throw [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo:nil];
}


- (NSUInteger) hash {
	NSUInteger ret = 0;
	id iter = [self entryIterator];
	while ([iter hasNext])
		ret += [[iter next] hash];
	return abs(ret);
}


- (NSString*) description {
	NSMutableString* s = [[NSMutableString stringWithFormat:@"%@, size = %d:\n", [[self class] description], [self size]] retain];
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		[s appendFormat:@"%@\n", [iter next]];
	}
	return [s autorelease];
}


- (BOOL) isEqual: (id) o {
	if (!([o class] == [self class])) return FALSE;
	id ourIter = [self entryIterator], iter = [o entryIterator];
	BOOL q1 = [ourIter hasNext], q2 = [iter hasNext];
	while (q1 || q2) {
		if (!q1 || !q2 || ![[ourIter next] isEqual: [iter next]]) return FALSE;
		q1 = [ourIter hasNext];
		q2 = [iter hasNext];
	}
	return TRUE;
}

- (BOOL) containsKey: (id) key {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		MapEntry* entry = [iter next];
		if ([entry.key isEqual: key]) {
			return TRUE;
		}
	}
	return FALSE;
}

- (BOOL) containsValue: (id) value {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		MapEntry* entry = [iter next];
		if ([entry.value isEqual: value]) {
			return TRUE;
		}
	}
	return FALSE;
}


- (id) get: (id) key {
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		MapEntry* entry = [iter next];
		if ([entry.key isEqual: key]) {
			return entry.value;
		}
	}
	return nil;
}


- (BOOL) isEmpty {
	return [self size] == 0;
}

- (void) putAll: (id<JBMap>) map {
	id iter = [map entryIterator];
	while ([iter hasNext]) {
		MapEntry* e = [iter next];
		[self putKey: e.key withValue: e.value];
	}
}

- (JBArray*) values {
	JBArray* arr = [[JBArray alloc] initWithSize: [self size]];
	int cnt = 0;
	id iter = [self entryIterator];
	while ([iter hasNext]) {
		MapEntry* e = [iter next];
		[arr set: e.value atIndex: cnt++];
	}
	return [arr autorelease];
}

- (id) copyWithZone: (NSZone*) zone {
	return [[[self class] alloc] initWithMap: self];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger) len {
	static id iter;
	
	if (state->state == 0) {
		iter = [self keyIterator];
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