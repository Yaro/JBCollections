#import <Foundation/Foundation.h>

@interface JBArrays : NSObject {
	
}

@end


void deleteArray (id* arr);
id* copyOf (id* arr, NSInteger len);
void copyAt (id* dest, NSInteger index, id* src, NSInteger len);
id* arrayWithLength (NSInteger len);