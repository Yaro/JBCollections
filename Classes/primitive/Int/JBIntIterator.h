#import "JBIntDefines.h"

@protocol JBIntIterator

- (BOOL) hasNext;
- (TYPE) next;

- (void) remove;

@end
