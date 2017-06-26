//
//  ZWAlertView.m
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "ZWAlertView.h"

#define ALTERTIME 1.5

@implementation ZWAlertView

+ (void)showAlterWithViewController:(UIViewController *)viewController Message:(NSString *)message {
    UIAlertController *shareController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    shareController.message = message;
    [viewController presentViewController:shareController animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:ALTERTIME target:self selector:@selector(timeAction:) userInfo:shareController repeats:NO];
}

+ (void)timeAction:(NSTimer *)timer {
    UIAlertController *alter = (UIAlertController *)[timer userInfo];
    [alter dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showAlertWithViewController:(UIViewController *)viewController Message:(NSString *)message Handler:(Handler)handler {
    if (!message) {
        message = @"提示消息为空";
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:handler]];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}


@end
