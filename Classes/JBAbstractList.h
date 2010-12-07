#import <Foundation/Foundation.h>
#import "JBAbstractCollection.h"
#import "JBList.h"

@interface JBAbstractList : JBAbstractCollection <JBList> {

}

@end


@interface LRNode : NSObject {
@public
	LRNode* myNextNode;
	LRNode* myPrevNode;
	id myItem;
}

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item;

@end