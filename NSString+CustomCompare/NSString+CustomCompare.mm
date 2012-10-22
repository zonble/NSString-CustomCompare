#import "NSString+CustomCompare.h"
#include <unicode/coll.h>

static Collator::EComparisonResult compareStringByPassingLocaleName(NSString *a, NSString *b, const char *localeName) 
{
	UErrorCode status = U_ZERO_ERROR; 
	const Locale& strokeLocale = Locale(localeName);
	Collator *coll = Collator::createInstance(strokeLocale, status); 
	if (U_SUCCESS(status)) {
		UnicodeString aStr = UnicodeString::fromUTF8([a UTF8String]);
		UnicodeString bStr = UnicodeString::fromUTF8([b UTF8String]);
		Collator::EComparisonResult result = coll->compare(aStr, bStr);
		delete coll;
		return result;
	}
	return Collator::EQUAL;
}

@implementation NSString (CustomCompare)

#define COMPARE(x) ((NSComparisonResult)compareStringByPassingLocaleName(self, anotherString, x))

- (NSComparisonResult)compareChineseByStrokeOrder:(NSString *)anotherString
{
	return COMPARE("zh@collation=stroke");
}
- (NSComparisonResult)compareChineseByPinyinOrder:(NSString *)anotherString
{
	return COMPARE("zh@collation=pinyin");
}
- (NSComparisonResult)compareChineseByBIG5Order:(NSString *)anotherString
{
	return COMPARE("zh@collation=big5han");
}
- (NSComparisonResult)compareChineseByGB2312Order:(NSString *)anotherString
{
	return COMPARE("zh@collation=gb2312");
}
- (NSComparisonResult)compareChineseByRadicalOrder:(NSString *)anotherString
{
	return COMPARE("zh@collation=unihan");
}

#undef COMPARE

@end
