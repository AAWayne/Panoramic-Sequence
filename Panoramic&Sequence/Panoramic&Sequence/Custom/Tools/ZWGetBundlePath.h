//
//  ZWGetBundlePath.h
//  智唯数码
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

typedef enum {
    JPEG = 0,
    JPG,
    PNG,
} ImageType;


#import <Foundation/Foundation.h>



@interface ZWGetBundlePath : NSObject


+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName;

+ (NSArray *)getBundlePathWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName;



+ (NSString *)getBundlePathWithBundleName:(NSString *)bundleName type:(ImageType)type;

+ (NSArray *)getBundlePathWithBundleName:(NSString *)bundleName imageName:(NSString *)imageName type:(ImageType)type;

+ (NSString *)getVedioBundlePathWithBundleName:(NSString *)bundleName vedioName:(NSString *)vedioName;


@end
