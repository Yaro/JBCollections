#import <Foundation/Foundation.h>
#import "JBSortedMap.h"
#import "JBAbstractMap.h"
#import "JBAbstractSortedMap.h"
@class TMapEntry;

@interface JBSplayTreeMap : JBAbstractSortedMap<JBSortedMap> {
	NSUInteger mySize;
	TMapEntry* myRoot;
}

@property (readonly, assign) NSUInteger size;

@end