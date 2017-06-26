//
//  ZWImageButton.h
//  zhiweism
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWImageButton : UIButton

/**
 图片按钮（有标题有图片）

 @param imageRect 图片的位置及大小
 @param titleRect 标题相对图片的位置及大小
 @return 重新布局
 */
- (instancetype)initWithImageRect:(CGRect)imageRect TitleRect:(CGRect)titleRect;

- (CGRect)titleRectForContentRect:(CGRect)contentRect;
- (CGRect)imageRectForContentRect:(CGRect)contentRect;

@end
