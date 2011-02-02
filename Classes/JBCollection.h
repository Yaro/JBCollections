#import "JBIterator.h"
#import "JBAbstractIterator.h"
#import "JBExceptions.h"
#import <Foundation/Foundation.h>
@class JBArray;
@class JBArrayList;

@protocol JBCollection<NSFastEnumeration, NSCopying>

@required

+ (id) withCollection: (id<JBCollection>) c;
+ (id) withObjects: (id) firstObject, ...;

- (BOOL) add: (id) o;
- (BOOL) addAll: (id<JBCollection>) c;
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

- (JBArray*) toJBArray;
- (NSMutableArray*) toNSArray;

- (BOOL) any: (BOOL(^)(id)) handler;
- (BOOL) all: (BOOL(^)(id)) handler;
- (JBArrayList*) select: (BOOL(^)(id)) handler;

@optional
- (id*) toArray;

@end