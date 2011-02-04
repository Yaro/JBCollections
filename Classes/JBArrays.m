#import "JBArrays.h"

@implementation JBArrays

@end

inline void deleteArray (id* arr) {
	free(arr);
}

inline id* copyOf (id* arr, NSInteger len) {
	id* ret = malloc(len * sizeof(id));
	memcpy(ret, arr, len * sizeof(id));
	return ret;
}

inline id* arrayWithLength (NSInteger len) {
	return calloc(len, sizeof(id));
}

inline id* resizeArray(id* arr, NSInteger nlen) {
	return realloc(arr, nlen * sizeof(id));
}

inline void copyAt (id* dest, NSInteger index, id* src, NSInteger len) {
	memcpy(dest + index, src, len * sizeof(id));
}