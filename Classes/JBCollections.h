#import <Foundation/Foundation.h>
#import "JBList.h"

@interface JBCollections : NSObject {

}

+ (void) sort: (id<JBList>) c with: (NSComparator) cmp;

@end

BOOL equals(id o1, id o2);