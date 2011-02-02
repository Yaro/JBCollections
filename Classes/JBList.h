@protocol JBList<JBCollection>

- (id) get: (NSInteger) index;
- (NSInteger) indexOf: (id) o;
- (id <JBList>) sublist: (NSRange) range;
- (id) set: (id) o at: (NSInteger) index;
- (id) removeAt: (NSInteger) index;
- (BOOL) isEqual: (id) o;

- (void) sort: (NSComparator) cmp;
- (void) reverse;

@end
