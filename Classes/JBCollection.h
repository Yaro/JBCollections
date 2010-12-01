@protocol JBCollection

@required

- (BOOL) add: (NSObject*) o;
- (BOOL) addAll: (id <JBCollection>) c;
- (void) clear;
- (BOOL) contains: (id) o;
- (BOOL) containsAll: (id <JBCollection>) c;
- (BOOL) isEqual: (id) o;
- (NSUInteger) hash;
- (BOOL) isEmpty;
- (BOOL) remove:(id) o;
- (BOOL) removeAll: (id <JBCollection>) c;
- (NSUInteger) size;
- (NSString*) toString;

@end
