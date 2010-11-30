@protocol JBQueue <JBCollection>

- (BOOL) add: (id) o;
- (id) peek;
- (id) poll;

@end
