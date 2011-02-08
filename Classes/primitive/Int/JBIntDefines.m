#import "JBIntDefines.h"

NSUInteger hash(TYPE x) {
	return x ^ 0x7e3b4ffa ^ (x << 3);
}

@implementation JBIntDefines

@end
