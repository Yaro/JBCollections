#import "JBCollection.h"

@protocol JBMap <NSFastEnumeration, NSCopying>

- (void) clear;
- (BOOL) containsKey: (id) key;
- (BOOL) containsValue: (id) value;
- (id) get: (id) key;
- (NSUInteger) hash;
- (BOOL) isEqual: (id) o;
- (BOOL) isEmpty;
- (id) putKey: (id) key withValue: (id) value;
- (void) putAll: (id<JBMap>) map;
- (id) initWithMap: (id<JBMap>) map;
- (id) initWithKeysAndObjects: (id) firstKey, ...;
- (id) remove: (id) key; // returns value associated with the key
- (NSUInteger) size;
- (NSString*) description;
- (JBArray*) values;
- (NSObject<JBIterator>*) keyIterator;
- (NSObject<JBIterator>*) entryIterator;

@end
