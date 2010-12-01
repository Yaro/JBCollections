#import <Foundation/Foundation.h>
#import "JBAbstractCollection.h"
#import "JBList.h"

@interface JBAbstractList : JBAbstractCollection <JBList> {

}

@end


typedef struct _LREntry* LREntryPtr;

/*typedef struct _REntry {
	id myItem;
	REntryPtr myNextItem;
} REntry;*/

typedef struct _LREntry {
	id myItem;
	LREntryPtr myNextItem, myPrevItem;
} LREntry;

LREntry MakeLREntry(id item, LREntry* next, LREntry* prev) {
	LREntry r;
	r.myItem = item;
	r.myNextItem = next;
	r.myPrevItem = prev;
	return r;
}