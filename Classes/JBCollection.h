#import "JBIterator.h"
#import "JBAbstractIterator.h"
#import "JBRandomAccess.h"
#import <Foundation/Foundation.h>
@class JBArray;

@protocol JBCollection <NSFastEnumeration>

@required

- (BOOL) add: (id) o;
- (BOOL) addAll: (id<JBCollection>) c;
- (void) clear;
- (BOOL) contains: (id) o;
- (BOOL) containsAll: (id<JBCollection>) c;
- (BOOL) isEqual: (id) o;
- (NSUInteger) hash;
- (BOOL) isEmpty;
- (BOOL) remove:(id) o;
- (BOOL) removeAll: (id<JBCollection>) c;
- (NSUInteger) size;
- (NSString*) toString;
- (NSObject<JBIterator>*) iterator;
- (id*) toArray;
- (JBArray*) toJBArray;

@end