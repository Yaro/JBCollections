#import "JBMap.h"
#import "JBArray.h"

@interface JBAbstractMap : NSObject<JBMap> {
	
}

@end

@interface MapEntry : NSObject {
@public
	id myKey, myValue;
}

@property (readonly) id key;
@property (readwrite, nonatomic, retain) id value;

- (id) initWithKey: (id) key value: (id) value;
- (NSString*) description;
- (NSUInteger) hash;
- (BOOL) isEqual: (id) o;

@end