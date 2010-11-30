@protocol JBMap

@required

- (void) clear;
- (BOOL) containsKey: (id) key;
- (BOOL) containsValue: (id) value;
- (id) get: (id) key;
- (NSUInteger) hash;
- (BOOL) isEqual: (id) o;
- (BOOL) isEmpty;
- (id) putKey: (id) key withValue: (id) value;
- (id) putAll: (id <JBMap>) map;
- (id) remove:(id) key; // returns value associated with the key
- (NSUInteger) size;
- (NSString*) toString;
- (id <JBCollection>) values;

@end
