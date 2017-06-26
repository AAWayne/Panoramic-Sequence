//
//  ZWGetBundlePath.m
//  智唯数码
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "ZWGetBundlePath.h"
#import "NSString+ZWStringDispose.h"

@implementation ZWGetBundlePath

//根据bundle文件名获取本地bundle文件
+ (NSString *)getBundlePath:(NSString *)bundleName {
    return [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
}

//图片后缀名
+ (NSString *)getTypeStr:(ImageType)type {
    NSString *typeStr;
    switch (type) {
        case JPEG:
            typeStr = @"jpeg";
            break;
        case JPG:
            typeStr = @"jpg";
            break;
        default:
            typeStr = @"png";
            break;
    }
    return typeStr;
}


//获取第一张图片作为封面
+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName {
    NSString *bundlePath = [self getBundlePath:bundleName];
    return [NSString stringWithFormat:@"%@/1", bundlePath];
}

//根据bundle文件名获取本地bundle文件 并根据提供的图片名字拿到里面的图片数组
+ (NSArray *)getBundlePathWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName {
    NSString *bundlePath = [self getBundlePath:bundleName];
    NSArray *imageNames = [imageName cutStringWithSymbol:@","];
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (NSString *name in imageNames) {
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@.jpg", bundlePath, name];
        [imagePaths addObject:imagePath];
    }
    return [imagePaths copy];
}


+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName type:(ImageType)type{
    NSString *bundlePath = [self getBundlePath:bundleName];
    NSString *typeStr = [self getTypeStr:type];
    return [NSString stringWithFormat:@"%@/1.%@", bundlePath, typeStr];
}

//根据bundle文件名获取本地bundle文件 并根据提供的图片名字拿到里面的图片数组
+ (NSArray *)getBundlePathWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName type:(ImageType)type {
    NSString *typeStr = [self getTypeStr:type];
    NSString *bundlePath = [self getBundlePath:bundleName];
    NSArray *imageNames = [imageName cutStringWithSymbol:@","];
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (NSString *name in imageNames) {
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@.%@", bundlePath, name, typeStr];
        [imagePaths addObject:imagePath];
    }
    return [imagePaths copy];
}

//根据bundle文件名获取本地bundle文件 并根据提供的图片名字拿到里面的图片数组
+ (NSString *)getVedioBundlePathWithBundleName:(NSString *)bundleName vedioName:(NSString *)vedioName {
    NSString *bundlePath = [self getBundlePath:bundleName];
    NSString *vedioPath = @"";
    NSArray *nameAndType = [vedioName cutStringWithSymbol:@"."];
    if (bundlePath.length > 0 && nameAndType.count == 2) {
        vedioPath = [NSString stringWithFormat:@"%@/%@.%@", bundlePath, nameAndType[0], nameAndType[1]];
    }
    return vedioPath;
}


@end
