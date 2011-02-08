#import "JBIntCollection.h"

@protocol JBIntList<JBIntCollection>

- (TYPE) get: (NSInteger) index;
- (NSInteger) indexOf: (TYPE) o;
- (TYPE) set: (TYPE) o at: (NSInteger) index;
- (TYPE) removeAt: (NSInteger) index;
- (BOOL) isEqual: (id) o;

- (TYPE) first;
- (TYPE) last;

- (void) sort;
- (void) reverse;

@end