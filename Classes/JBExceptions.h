#import <Foundation/Foundation.h>


@interface JBExceptions : NSObject {

}

+ (NSException*) needComparator;
+ (NSException*) unsupportedOperation;
+ (NSException*) indexOutOfBounds: (NSInteger) index size: (NSInteger) n;
+ (NSException*) noIterator;
+ (NSException*) invalidArgument: (id) arg;

@end
