//
//  ZWRootTabBarController.m
//  Panoramic&Sequence
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "ZWRootTabBarController.h"

#import "ZWPanoramicViewController.h"
#import "ZWSequenceViewController.h"


@interface ZWRootTabBarController ()

@property (nonatomic, strong)NSMutableArray <UINavigationController *>* VCArray;


@end

@implementation ZWRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializUI];
}


//界面初始化
- (void)initializUI {

    NSArray *viewControllers = @[[ZWPanoramicViewController new],[ZWSequenceViewController new]];
    NSArray *titles = @[@"全景图展示", @"序列帧展示"];
    _VCArray = [NSMutableArray array];
    //循环赋值
    for (int i = 0; i<viewControllers.count; i++) {
        UIViewController * vc = viewControllers[i];
        UITabBarItem * item = [[UITabBarItem alloc] init];
        vc.tabBarItem = item;
        vc.title = titles[i];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        //设置导航控制器主题色
//        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        nav.navigationBar.hidden = YES;
        [_VCArray addObject:nav];
    }
    
    self.viewControllers = _VCArray;

}

@end
