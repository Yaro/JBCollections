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

@property (readwrite, nonatomic, assign) LRNode* nextNode,* prevNode;
@property (readwrite, nonatomic, assign) id item;

//better "assign", cause we don't actually own instance variables, the structure does

+ (id) createNodeWithPrev: (LRNode*) prevNode next: (LRNode*) nextNode item: (id) item;

@end