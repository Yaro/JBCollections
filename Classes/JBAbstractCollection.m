#import "JBAbstractCollection.h"
#import "JBArray.h"

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

- (<JBIterator>) iterator {
	@throw [NSException exceptionWithName:@"No iterator in collection" reason:@"" userInfo:nil];
}

- (void) dealloc {
	[self clear];
	[super dealloc];
}

//hmm...
- (JBArray*) toArray {
	JBArray* arr = [[JBArray createWithSize: [self size]] retain];
	<JBIterator> iter = [self iterator];
	for (int i = 0; i < [self size]; i++) {
		[arr set:[iter next] atIndex:i];
	}
	return [arr autorelease];
}

- (NSUInteger) countByEnumeratingWithState: (NSFastEnumerationState*) state objects: (id*) stackbuf count: (NSUInteger)len {
	@throw [NSException exceptionWithName:@"No fast enumeration yet" reason:@"" userInfo:nil];
	//convenient fast enumeration later
	
	/*NSUInteger count = 0;
	if (state->state == 0) {
		JBArray* arr = [self toArray];
		state->
	}*/
}

@end
