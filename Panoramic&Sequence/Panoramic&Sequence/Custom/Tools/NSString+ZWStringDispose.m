//
//  NSString+ZWStringDispose.m
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "NSString+ZWStringDispose.h"

@implementation NSString (ZWStringDispose)

// 截取某段字符串之间的 字符串 方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString {
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

- (NSArray *)cutStringWithSymbol:(NSString *)symbol {
    NSArray *stringArray;
    //字条串是否包含有某字符串
    if ([self rangeOfString:symbol].location == NSNotFound) {
        //不存在包含字符串
        stringArray = @[self];
    } else {
        //按符号进行分割
        stringArray = [self componentsSeparatedByString:symbol];
    }
    return stringArray;
}


@end
