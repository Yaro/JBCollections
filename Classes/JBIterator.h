@protocol JBIterator

- (BOOL) hasNext;
- (id) next;
// optional method
- (void) remove;

@end
