//
//  ZWImageButton.m
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//



#import "ZWImageButton.h"

@interface ZWImageButton ()

//传入定位
@property(nonatomic, assign) CGRect titleRect;
@property(nonatomic, assign) CGRect imageRect;

@end

@implementation ZWImageButton

- (instancetype)initWithImageRect:(CGRect)imageRect TitleRect:(CGRect)titleRect {
    self = [super init];
    if (self) {
        self.titleRect = titleRect;
        self.imageRect = imageRect;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return self.titleRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return self.imageRect;
}

@end
