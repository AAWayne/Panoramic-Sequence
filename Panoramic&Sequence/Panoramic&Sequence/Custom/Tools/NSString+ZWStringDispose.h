//
//  NSString+ZWStringDispose.h
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSString (ZWStringDispose)

// 截取某段字符串之间的 字符串 方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

//分割字符串
- (NSArray  *)cutStringWithSymbol:(NSString *)symbol;


@end
