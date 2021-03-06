#import "JBMapEntry.h"
#import "JBCollections.h"

@implementation JBMapEntry

@synthesize key = myKey, value = myValue;

- (NSUInteger) hash {
	return [myKey hash] + [myValue hash];
}

- (BOOL) isEqual: (id) o {
	return [o isKindOfClass: [JBMapEntry class]] && equals([o key], myKey) && equals([o value], myValue);
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

- (void) dealloc {
	[myKey release];
	[myValue release];
	[super dealloc];
}

@end