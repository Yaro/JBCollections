#import "JBIterator.h"
#import "JBAbstractIterator.h"
#import "JBExceptions.h"
#import <Foundation/Foundation.h>
@class JBArray;

@protocol JBCollection<NSFastEnumeration, NSCopying>

@required

- (BOOL) add: (id) o;
- (BOOL) addAll: (id<JBCollection>) c;
- (id) initWithCollection: (id<JBCollection>) c;
- (id) initWithObjects: (id) firstObject, ...;
- (void) clear;
- (BOOL) contains: (id) o;
- (BOOL) containsAll: (id<JBCollection>) c;
- (NSUInteger) hash;
- (BOOL) isEmpty;
- (BOOL) remove: (id) o;
- (BOOL) removeAll: (id<JBCollection>) c;
- (NSUInteger) size;
- (NSString*) description;
- (NSObject<JBIterator>*) iterator;
- (id*) toArray;
- (JBArray*) toJBArray;

@end