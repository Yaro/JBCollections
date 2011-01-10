#import "JBExceptions.h"


@implementation JBExceptions

+ (NSException*) needComparator {
	return [NSException exceptionWithName: @"initialization with comparator required" reason: @"" userInfo: nil];
}

+ (NSException*) unsupportedOperation {
	return [NSException exceptionWithName: @"Unsupported operation exception" reason: @"" userInfo: nil];
}

+ (NSException*) indexOutOfBounds: (NSInteger) index size: (NSInteger) n {
	return [NSException exceptionWithName: @"Index out of bounds: " 
				reason: [NSString stringWithFormat: @"Index = %d, Size = %d", index, n] userInfo: nil];
}

+ (NSException*) noIterator {
	return [NSException exceptionWithName: @"No iterator in collection" reason: @"" userInfo: nil];
}



@end
