@protocol JBList <JBCollection>

@required

- (id) get: (NSInteger) index;
- (NSInteger) indexOf: (id) o;
- (id <JBList>) subListInRange: (NSRange) range;
- (id) setObject: (id) o atIndex: (NSInteger) index;

@end
