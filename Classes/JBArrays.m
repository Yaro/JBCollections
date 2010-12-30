#import "JBArrays.h"

@implementation JBArrays

@end

void deleteArray (id* arr) {
	if (arr) {
		free(arr);
	}
}

id* copyOf (id* arr, NSInteger len) {
	if (len <= 0) {
		@throw [NSException exceptionWithName: @"bad array size in copying procedure" 
				reason: [NSString stringWithFormat: @"length = %d", len] userInfo: nil];
	}
	id* ret = malloc(len * sizeof(id));
	if (!ret) {
		@throw [NSException exceptionWithName: @"bad array allocation" 
				reason: [NSString stringWithFormat: @"length = %d", len] userInfo: nil];
	}
	memcpy(ret, arr, len * sizeof(id));
	return ret;
}

id* arrayWithLength (NSInteger len) {
	if (len <= 0) {
		@throw [NSException exceptionWithName: @"bad array size in creation procedure"
				reason: [NSString stringWithFormat:@"length = %d", len] userInfo: nil];
	}
	id* arr = calloc(len, sizeof(id));
	if (!arr) {
		@throw [NSException exceptionWithName: @"bad array allocation"
				reason: [NSString stringWithFormat:@"length = %d", len] userInfo: nil];
	}
	return arr;
}

void copyAt (id* dest, NSInteger index, id* src, NSInteger len) {
	memcpy(dest + sizeof(id) * index, src, len * sizeof(id));
}