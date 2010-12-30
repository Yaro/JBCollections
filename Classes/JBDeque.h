@protocol JBDeque<JBCollection>

- (void) addFirst: (id) o;
- (void) addLast: (id) o;
- (id) first;
- (id) last;
- (id) removeLast;
- (id) removeFirst;

@end
