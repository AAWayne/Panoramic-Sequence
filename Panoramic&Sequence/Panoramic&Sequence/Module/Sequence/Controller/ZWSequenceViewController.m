//
//  ZWSequenceViewController.m
//  Panoramic&Sequence
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "ZWSequenceViewController.h"
#import "ZWSpinImageView.h"



@interface ZWSequenceViewController () <ZWSpinImageViewDelegate> {
    CGFloat _spaceX;
    CGFloat _spaceY;
}

@property (nonatomic, strong) ZWSpinImageView           *spinImageView;

@property (nonatomic, strong) ZWImageButton             *autoMoveBtn;           //自动前进按钮
@property (nonatomic, strong) ZWImageButton             *moveForwardBtn;        //向前进按钮
@property (nonatomic, strong) ZWImageButton             *moveBackBtn;           //向后退按钮
@property (nonatomic, strong) UIImageView               *gesturesImageView;     //手势图片


@end


@implementation ZWSequenceViewController

- (void)dealloc {
    //销毁视图
    [self removeSpinImageView];
    [[NSNotificationCenter defaultCenter] removeObserver:@"AlertPrompt"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"StopAutoMove"];
}

- (void)onNotification:(NSNotification *)notification {
    
    if ([notification.name isEqualToString:@"AlertPrompt"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *alertMessage = @"哎呀，已经到达世界尽头咯！";
        if (userInfo[@"moveBack"]) {
            alertMessage = @"O_O，还没开始呢，就想后退了...";
        }
        NSLog(@"alertMessage -> %@", alertMessage);
        [ZWAlertView showAlterWithViewController:self Message:alertMessage];
    } else if ([notification.name isEqualToString:@"StopAutoMove"]) {
        //取消自动播放
        [self autoStatus:NO];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"AlertPrompt" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"StopAutoMove" object:nil];
    
    [self initUI];
    [self loadImageData];

}

//界面初始化
- (void)initUI {
    
    _spaceX = SCREEN_WIDTH - 150;
    _spaceY = SCREEN_HEIGHT - 220;
    
    
    [self.spinImageView addSubview:self.autoMoveBtn];
    [self.spinImageView addSubview:self.moveForwardBtn];
    [self.spinImageView addSubview:self.moveBackBtn];
    [self.spinImageView addSubview:self.gesturesImageView];
    
    [self.view addSubview:self.spinImageView];
    
}


//加载图片
- (void)loadImageData {
    self.spinImageView.imagesArray = [self getImagePathsWithBundleName:@"序列帧展示" num:150];
}

//从.bundle文件中 获取图片路径
- (NSArray *)getImagePathsWithBundleName:(NSString *)bundleName num:(NSInteger)num{
    //自定义的.bundle文件也存在与应用的主目录下，所以还是需要从主目录来拼接路径
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (!bundlePath) {
        [ZWAlertView showAlterWithViewController:self Message:@"图片资源不存在"];
    }
    NSMutableArray *imagePaths = [NSMutableArray array];
    for (int i = 0; i <= num; i++) {
        [imagePaths addObject:[NSString stringWithFormat:@"%@/JJ_%05d.jpeg", bundlePath, i]];
    }
    return [imagePaths copy];
}



#pragma mark -- action
- (void)onImageButton:(ZWImageButton *)sender {
    switch (sender.tag) {
        case 1001:{//自动前进
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self autoStatus:YES];
            } else {
                [self autoStatus:NO];
            }
            break;
        }
        case 1002://前进
            [self.spinImageView moveForward];
            break;
        case 1003://后退
            [self.spinImageView moveBack];
            
            break;
            
        default:
            break;
    }
}

- (void)autoStatus:(BOOL)isAutoStatus {
    //自动
    if (isAutoStatus) {
        [self.spinImageView autoMoveForward];
        self.moveBackBtn.userInteractionEnabled = NO;
        self.moveForwardBtn.userInteractionEnabled = NO;
        self.moveBackBtn.selected = YES;
        self.moveForwardBtn.selected = YES;
        //停止
    } else {
        self.autoMoveBtn.selected = NO;
        [self.spinImageView stopMove];
        self.moveBackBtn.userInteractionEnabled = YES;
        self.moveForwardBtn.userInteractionEnabled = YES;
        self.moveBackBtn.selected = NO;
        self.moveForwardBtn.selected = NO;
    }
}


//销毁视图
- (void)removeSpinImageView {
    [self.spinImageView removeFromSuperview];
    self.spinImageView = nil;
}

#pragma mark -  SpinImageViewDelegate
- (void)spinImageViewBeginLoadData:(ZWSpinImageView *)view {
    NSLog(@"开始加载数据");
    
}
- (void)spinImageViewEndLoadData:(ZWSpinImageView *)view {
    NSLog(@"加载数据结束");
    
}
- (void)spinImageViewFailedLoadData:(ZWSpinImageView *)view {
    [ZWAlertView showAlertWithViewController:self Message:@"数据加载错误" Handler:^(UIAlertAction *handler) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)spinImageView:(ZWSpinImageView *)view didSelectAtIndex:(NSInteger)index {
    NSLog(@"当前展示下标 - %ld", index);

}

#pragma mark -- getter
- (ZWSpinImageView *)spinImageView {
    if (!_spinImageView) {
        _spinImageView = [[ZWSpinImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _spinImageView.delegate = self;
        //是否可循环
        _spinImageView.isRepeat = NO;//默认是NO;
    }
    return _spinImageView;
}


- (ZWImageButton *)autoMoveBtn {
    if (!_autoMoveBtn) {
        CGFloat imgW = 40;
        CGFloat labW = 80;
        ZWImageButton *imageBtn = [[ZWImageButton alloc] initWithImageRect:CGRectZero TitleRect:CGRectMake(imgW * 1.5, 0, labW, imgW)];
        imageBtn.frame = CGRectMake(_spaceX, _spaceY, imgW + labW, imgW);
        imageBtn.tag = 1001;
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:18];

        [imageBtn setTitle:@"自动" forState:UIControlStateNormal];
        [imageBtn setTitle:@"停止" forState:UIControlStateSelected];
        [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [imageBtn addTarget:self action:@selector(onImageButton:) forControlEvents:UIControlEventTouchUpInside];
        _autoMoveBtn = imageBtn;
    }
    return _autoMoveBtn;
}

- (ZWImageButton *)moveForwardBtn {
    if (!_moveForwardBtn) {
        CGFloat imgW = 40;
        CGFloat labW = 80;
        CGFloat btnW = imgW + labW;
        ZWImageButton *imageBtn = [[ZWImageButton alloc] initWithImageRect:CGRectZero TitleRect:CGRectMake(imgW * 1.5, 0, labW, imgW)];
        imageBtn.frame = CGRectMake(_spaceX, CGRectGetMaxY(self.autoMoveBtn.frame) + 20, btnW, imgW);
        imageBtn.tag = 1002;
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:18];

        [imageBtn setTitle:@"前进" forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        
        [imageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [imageBtn addTarget:self action:@selector(onImageButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _moveForwardBtn = imageBtn;
    }
    return _moveForwardBtn;
}

- (ZWImageButton *)moveBackBtn {
    if (!_moveBackBtn) {
        CGFloat imgW = 40;
        CGFloat labW = 80;
        ZWImageButton *imageBtn = [[ZWImageButton alloc] initWithImageRect:CGRectZero TitleRect:CGRectMake(imgW * 1.5, 0, labW, imgW)];
        imageBtn.frame = CGRectMake(_spaceX, CGRectGetMaxY(self.moveForwardBtn.frame) + 20, imgW + labW, imgW);
        imageBtn.tag = 1003;
        imageBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [imageBtn setTitle:@"后退" forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [imageBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        
        [imageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [imageBtn addTarget:self action:@selector(onImageButton:) forControlEvents:UIControlEventTouchUpInside];
        _moveBackBtn = imageBtn;
    }
    return _moveBackBtn;
}
- (UIImageView *)gesturesImageView {
    if (!_gesturesImageView) {
        CGFloat imageW = 400;
        CGFloat imageH = 100;
        _gesturesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GestureGude.png"]];
        _gesturesImageView.frame = CGRectMake((SCREEN_WIDTH - imageW) / 2, SCREEN_HEIGHT - 2 * imageH , imageW, imageH);
    }
    return _gesturesImageView;
}

@end
