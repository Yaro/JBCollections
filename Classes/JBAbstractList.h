#import <Foundation/Foundation.h>
#import "JBAbstractCollection.h"
#import "JBList.h"

@interface JBAbstractList : JBAbstractCollection <JBList> {

}

@end


typedef struct _LRNode* LRNodePtr;

/*typedef struct _RNode {
	id myItem;
	RNodePtr myNextNode;
} RNode;*/

/*typedef struct _LRNode {
	id myItem;
	LRNodePtr myNextNode, myPrevNode;
} LRNode;

static LRNode MakeLRNode(id item, LRNode* next, LRNode* prev) {
	LRNode r;
	r.myItem = item;
	r.myNextNode = next;
	r.myPrevNode = prev;
	return r;
}*/

@interface LRNode : NSObject {
@public
	LRNode* myNextNode;
	LRNode* myPrevNode;
	id myItem;
}

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item;

@end

