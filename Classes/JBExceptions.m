#import "JBExceptions.h"


@implementation JBExceptions

+ (NSException*) needComparator {
	return [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

+ (NSException*) unsupportedOperation {
	return [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo: nil];
}

+ (NSException*) indexOutOfBounds {
	return [NSException exceptionWithName: @"Index out of bounds" reason: @"" userInfo: nil];
}

@end
