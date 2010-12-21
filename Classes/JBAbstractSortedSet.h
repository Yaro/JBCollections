#import <Foundation/Foundation.h>
#import "JBSortedMap.h"
#import "JBAbstractMap.h"
#import "JBSortedSet.h"

@interface JBAbstractSortedSet : JBAbstractCollection<JBSortedSet> {
	JBAbstractMap<JBSortedMap>* myMap;
}

@property (readonly) NSComparator comparator;

@end
