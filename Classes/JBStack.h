#import <Foundation/Foundation.h>
#import	 "JBLinkedList.h"

@interface JBStack : JBLinkedList {
	
}

- (BOOL) empty;
- (id) peek;
- (id) pop;
- (void) push: (id) o;

@end
