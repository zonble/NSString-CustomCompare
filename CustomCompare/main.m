#import <Foundation/Foundation.h>
#import "NSString+CustomCompare.h"

int main(int argc, const char * argv[])
{
	@autoreleasepool {
		NSArray *a = [NSArray arrayWithObjects:@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"百", @"千", @"萬", nil];

//		NSLog(@"Stroke:%@", [[a sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//			return [obj1 compareChineseByStrokeOrder:obj2];
//		}] componentsJoinedByString:@","]);
//		NSLog(@"Pinyin:%@", [[a sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//			return [obj1 compareChineseByPinyinOrder:obj2];
//		}] componentsJoinedByString:@","]);
//		NSLog(@"BIG5:%@", [[a sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//			return [obj1 compareChineseByBIG5Order:obj2];
//		}] componentsJoinedByString:@","]);
//		NSLog(@"GB2312:%@", [[a sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//			return [obj1 compareChineseByGB2312Order:obj2];
//		}] componentsJoinedByString:@","]);

		NSLog(@"Stroke:%@", [[a sortedArrayUsingSelector:@selector(compareChineseByStrokeOrder:)] componentsJoinedByString:@","]);
		NSLog(@"Pinyin:%@", [[a sortedArrayUsingSelector:@selector(compareChineseByPinyinOrder:)] componentsJoinedByString:@","]);
		NSLog(@"BIG5:%@", [[a sortedArrayUsingSelector:@selector(compareChineseByBIG5Order:)] componentsJoinedByString:@","]);
		NSLog(@"GB2312:%@", [[a sortedArrayUsingSelector:@selector(compareChineseByGB2312Order:)] componentsJoinedByString:@","]);
		NSLog(@"Radical:%@", [[a sortedArrayUsingSelector:@selector(compareChineseByRadicalOrder:)] componentsJoinedByString:@","]);
	}
    return 0;
}

