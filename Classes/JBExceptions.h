#import <Foundation/Foundation.h>


@interface JBExceptions : NSObject {

}

+ (NSException*) needComparator;
+ (NSException*) unsupportedOperation;
+ (NSException*) indexOutOfBounds;

@end
