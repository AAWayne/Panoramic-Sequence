//
//  ZWAlertView.h
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^Handler)(UIAlertAction *handler);


@interface ZWAlertView : NSObject

+ (void)showAlterWithViewController:(UIViewController *)viewController Message:(NSString *)message;


+ (void)showAlertWithViewController:(UIViewController *)viewController Message:(NSString *)message Handler:(Handler)handler;

@end
