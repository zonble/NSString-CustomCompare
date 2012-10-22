#import "NSString+CustomCompare.h"
#ifdef CPP
	#include <unicode/coll.h>
#else
	#include <unicode/ucol.h>
#endif

#ifdef USE_CPP_API

static Collator::EComparisonResult compareStringByPassingLocaleName(NSString *a, NSString *b, const char *localeName) 
{
	UErrorCode status = U_ZERO_ERROR; 
	const Locale& strokeLocale = Locale(localeName);
	Collator* coll = Collator::createInstance(strokeLocale, status); 
	if (U_SUCCESS(status)) {
		UnicodeString aStr = UnicodeString::fromUTF8([a UTF8String]);
		UnicodeString bStr = UnicodeString::fromUTF8([b UTF8String]);
		Collator::EComparisonResult result = coll->compare(aStr, bStr);
		delete coll;
		return result;
	}
	return Collator::EQUAL;
}

#else 

static UCollationResult compareStringByPassingLocaleName(NSString *a, NSString *b, const char *localeName) 
{
	UErrorCode status = U_ZERO_ERROR;
	UCollator * collator = ucol_open(localeName, &status);
	NSUInteger strLenA = [a length];
	NSUInteger strLenB = [b length];
	UChar aStr[strLenA];
	UChar bStr[strLenB];
	u_strFromUTF8(aStr, strLenA, NULL, [a UTF8String], -1, &status);
	u_strFromUTF8(aStr, strLenB, NULL, [b UTF8String], -1, &status);
	ucol_close(collator);
	return ucol_strcoll(collator, aStr, strLenA, bStr, strLenB);	
}

#endif

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
