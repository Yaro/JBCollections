#import "JBCollection.h"

@protocol JBMap<NSFastEnumeration, NSCopying>

+ (id) withMap: (id<JBMap>) map;
+ (id) withKeysAndObjects: (id) firstKey, ...;

- (void) clear;
- (BOOL) containsKey: (id) key;
- (BOOL) containsValue: (id) value;
- (id) get: (id) key;
- (NSUInteger) hash;
- (BOOL) isEmpty;
- (id) putKey: (id) key withValue: (id) value;
- (void) putAll: (id<JBMap>) map;

- (id) remove: (id) key;
- (NSUInteger) size;
- (NSString*) description;
- (JBArray*) values;
- (NSObject<JBIterator>*) keyIterator;
- (NSObject<JBIterator>*) entryIterator;

@end
