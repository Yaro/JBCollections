#import <Foundation/Foundation.h>
#import "JBIntIterator.h"
#import "JBIntAbstractIterator.h"
#import "JBExceptions.h"

@class JBIntArray;
@class JBIntArrayList;
@class JBArray;

@protocol JBIntCollection<NSCopying>

+ (id) withCollection: (id<JBIntCollection>) c;

- (BOOL) add: (TYPE) o;
- (BOOL) addAll: (id<JBIntCollection>) c;
- (void) clear;
- (BOOL) contains: (TYPE) o;
- (BOOL) containsAll: (id<JBIntCollection>) c;
- (NSUInteger) hash;
- (BOOL) isEmpty;
- (BOOL) remove: (TYPE) o;
- (BOOL) removeAll: (id<JBIntCollection>) c;
- (NSUInteger) size;
- (NSString*) description;
- (NSObject<JBIntIterator>*) iterator;

- (JBIntArray*) toJBIntArray;
- (JBArray*) toJBArray;

- (BOOL) any: (BOOL(^)(TYPE)) handler;
- (BOOL) all: (BOOL(^)(TYPE)) handler;
- (JBIntArrayList*) select: (BOOL(^)(TYPE)) handler;


@end