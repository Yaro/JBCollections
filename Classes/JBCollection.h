#import "JBArray.h"
#import "JBIterator.h"

@protocol JBCollection <NSFastEnumeration>

@required

- (BOOL) add: (id) o;
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
- (id <JBIterator>) iterator;

@optional
//hmm...
- (JBArray*) toArray;

@end
