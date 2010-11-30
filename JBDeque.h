@protocol JBDeque <JBCollection>
- (void) addFirst: (id) o;
- (void) addLast: (id) o;
- (id) getFirst;
- (id) getLast;
- (id) removeLast;
- (id) removeFirst;

@end
