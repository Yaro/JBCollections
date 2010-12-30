#import <Foundation/Foundation.h>


@interface JBMapEntry : NSObject {
@public
	id myKey, myValue;
}

@property (readwrite, nonatomic, retain) id key;
@property (readwrite, nonatomic, retain) id value;

- (id) initWithKey: (id) key value: (id) value;
- (NSString*) description;
- (NSUInteger) hash;
- (BOOL) isEqual: (id) o;

@end