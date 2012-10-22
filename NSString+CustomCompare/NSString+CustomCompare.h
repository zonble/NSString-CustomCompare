#import <Foundation/Foundation.h>

@interface NSString (CustomCompare)

- (NSComparisonResult)compareChineseByStrokeOrder:(NSString *)anotherString;
- (NSComparisonResult)compareChineseByPinyinOrder:(NSString *)anotherString;
- (NSComparisonResult)compareChineseByBIG5Order:(NSString *)anotherString;
- (NSComparisonResult)compareChineseByGB2312Order:(NSString *)anotherString;
- (NSComparisonResult)compareChineseByRadicalOrder:(NSString *)anotherString;

@end
