NSString-CustomCompare
======================

> **Legacy Project Notice:** This project targets macOS 10.7 and uses
> manual reference counting (MRC). It is no longer actively maintained,
> but the code is still functional and serves as a useful reference for
> Chinese text collation on Apple platforms.

A lightweight Objective-C category on `NSString` that makes it easy to
sort Chinese text in five different collation orders using the ICU
library (or the equivalent Cocoa `NSLocale` API).

## Overview

Standard lexicographic comparison is usually not meaningful for Chinese
characters. Depending on the audience or application context, users
expect lists to be ordered differently—by stroke count, by Mandarin
pronunciation (Pinyin), by Traditional-Chinese encoding (Big5), by
Simplified-Chinese encoding (GB 2312), or by radical and stroke (Unihan
order).

`NSString+CustomCompare` wraps the ICU collation rules exposed through
`NSLocale` into five convenient instance methods so you can sort arrays
of Chinese strings without writing any locale boilerplate yourself.

## API

```objc
// Sort by stroke count of the first character.
- (NSComparisonResult)compareChineseByStrokeOrder:(NSString *)anotherString;

// Sort by Mandarin pronunciation (Pinyin).
- (NSComparisonResult)compareChineseByPinyinOrder:(NSString *)anotherString;

// Sort by Traditional-Chinese Big5 code-point order.
- (NSComparisonResult)compareChineseByBIG5Order:(NSString *)anotherString;

// Sort by Simplified-Chinese GB 2312 code-point order.
- (NSComparisonResult)compareChineseByGB2312Order:(NSString *)anotherString;

// Sort by Unihan radical-then-stroke order.
- (NSComparisonResult)compareChineseByRadicalOrder:(NSString *)anotherString;
```

Each method returns a standard `NSComparisonResult`
(`NSOrderedAscending`, `NSOrderedSame`, or `NSOrderedDescending`) so
it works directly with all the standard Cocoa sorting APIs.

## Usage

### Sorting an array with a selector

```objc
#import "NSString+CustomCompare.h"

NSArray *names = @[@"萬", @"一", @"三", @"七", @"百", @"千", @"九", @"二"];

// Sort by stroke order
NSArray *byStroke = [names sortedArrayUsingSelector:
                     @selector(compareChineseByStrokeOrder:)];

// Sort by Pinyin pronunciation
NSArray *byPinyin = [names sortedArrayUsingSelector:
                     @selector(compareChineseByPinyinOrder:)];
```

### Sorting with a block comparator (OS X 10.6+)

```objc
NSArray *byRadical = [names sortedArrayUsingComparator:
    ^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compareChineseByRadicalOrder:obj2];
    }];
```

### Direct pairwise comparison

```objc
NSComparisonResult result = [@"三" compareChineseByStrokeOrder:@"二"];
// result == NSOrderedDescending  (三 has more strokes than 二)
```

## Installation

This project does not include a CocoaPod or Swift Package; add the
files directly to your project:

1. Copy `NSString+CustomCompare.h` and `NSString+CustomCompare.mm`
   into your Xcode project.
2. Make sure the file is compiled as **Objective-C++** (`.mm`
   extension handles this automatically).
3. Link against **`libicucore.dylib`** (add it in *Build Phases →
   Link Binary With Libraries*).
4. `#import "NSString+CustomCompare.h"` wherever you need it.

## Implementation Details

The category provides three interchangeable back-ends. Only one is
compiled at a time, controlled by preprocessor macros at the top of
`NSString+CustomCompare.mm`:

| Macro | Back-end | Notes |
|---|---|---|
| `USE_CPP_API` | ICU C++ `Collator` | Requires linking the full ICU C++ library |
| `USE_C_API` | ICU C `ucol_*` functions | Lower-level, no C++ runtime required |
| *(neither)* | Cocoa `NSLocale` + `NSString -compare:options:range:locale:` | **Default.** No extra linkage needed beyond `libicucore.dylib` |

The default Cocoa back-end delegates to the same underlying ICU
collation data that ships with macOS, so all three back-ends produce
identical results.

Each back-end calls a file-static helper
`compareStringByPassingLocaleName(a, b, localeName)` and passes one of
the following ICU locale identifiers:

| Method | Locale identifier |
|---|---|
| `compareChineseByStrokeOrder:` | `zh@collation=stroke` |
| `compareChineseByPinyinOrder:` | `zh@collation=pinyin` |
| `compareChineseByBIG5Order:` | `zh@collation=big5han` |
| `compareChineseByGB2312Order:` | `zh@collation=gb2312` |
| `compareChineseByRadicalOrder:` | `zh@collation=unihan` |

## Requirements

* macOS 10.7 or later
* Xcode 4 or later
* **Automatic Reference Counting (ARC) must be disabled** for
  `NSString+CustomCompare.mm` (the file uses `[locale release]`). If
  your project uses ARC, add the `-fno-objc-arc` compiler flag to this
  file under *Build Phases → Compile Sources*.
