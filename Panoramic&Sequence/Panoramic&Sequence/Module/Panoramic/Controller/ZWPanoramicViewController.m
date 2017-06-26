//
//  ZWPanoramicViewController.m
//  Panoramic&Sequence
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 90candy. All rights reserved.
//

#import "ZWPanoramicViewController.h"

#import "PLView.h"


@interface ZWPanoramicViewController ()<PLViewDelegate>

@property (nonatomic, strong) PLView            * plView;
@property (nonatomic, strong) NSArray           * dataSource;

@end

@implementation ZWPanoramicViewController

- (void)dealloc {
    [self.plView clear];
    [self.plView removeFromSuperview];
    self.plView.delegate = nil;
    self.plView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDataSource];
    
    [self initUI];
    
}

- (void)initUI {
    [self.view addSubview:self.plView];
}

- (void)initDataSource {
    //加载 - 六方图
    [self loadDataSixPartyFigureWithBundleName:@"全景展示六方图"];
    //加载 - 单张球型图
//    [self loadDataOne];
}

//加载六方全景图
- (void)loadDataSixPartyFigureWithBundleName:(NSString *)bundleName {
    [self.plView clear];
    NSObject<PLIPanorama> *panorama = nil;
    //六方图
    PLCubicPanorama *cubicPanorama = [PLCubicPanorama panorama];
    NSArray *imagePaths = [self getImagePathsWithBundleName:bundleName];
    //用六方图的图片来实现 图片拼接，拼成一个正方体。
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[0]] face:PLCubeFaceOrientationFront];
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[1]] face:PLCubeFaceOrientationBack];
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[2]] face:PLCubeFaceOrientationLeft];
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[3]] face:PLCubeFaceOrientationRight];
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[4]] face:PLCubeFaceOrientationUp];
    [cubicPanorama setTexture:[PLTexture textureWithImagePath:imagePaths[5]] face:PLCubeFaceOrientationDown];
    
    //    [cubicPanorama setTexture:[PLTexture textureWithImage:[PLImage imageWithPath:imagePaths[5]]] face:PLCubeFaceOrientationDown];
    //改变初始化的位置(点击全景进去是指定的某一个角度) - yaw是横向，pitch是纵向
    [panorama.currentCamera lookAtWithPitch:0.0f yaw:0.0f];
    panorama = cubicPanorama;
    //添加热点(这个类可以实现在全景里面添加按钮，并且按钮跟随场景的转动而转动。有的需求是，当转动到某一个页面时，随之出现一个按钮)
    //    PLTexture *hotspotTexture = [PLTexture textureWithImage:[PLImage imageWithPath:[[NSBundle mainBundle] pathForResource:@"hotspot" ofType:@"png"]]];
    //角度是相对场景而调整,
    //width，height 热点大小 atv上正数下负数 ath 位置右边正数 左边负数
    //热点为多个时 设置热点id即可区别点击的哪一个热点
    //    PLHotspot *hotspot = [PLHotspot hotspotWithId:1 texture:hotspotTexture atv:185.0f ath:-30.0f width:0.05 height:0.05];
    //    [panorama addHotspot:hotspot];
    [self.plView setPanorama:panorama];
}

//加载单张全景图
- (void)loadDataOne {
    _plView = [[PLView alloc] initWithFrame:self.view.bounds];
    _plView.delegate = self;
    NSObject<PLIPanorama> *panorama = nil;
    //迪拜2048x1024
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"test2048x1024" ofType:@"jpg"];
    if (!imagePath) {
        [ZWAlertView showAlertWithViewController:self Message:@"图片资源不存在" Handler:^(UIAlertAction *handler) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    //2048 * 1024
    panorama = [PLSphericalPanorama panorama];
    [(PLSphericalPanorama *)panorama setImage:[PLImage imageWithPath:imagePath]];
    
    [_plView setPanorama:panorama];
    [self.view addSubview:_plView];
    
}

//热点的点击事件
-(void)view:(UIView<PLIView> *)pView didClickHotspot:(PLHotspot *)hotspot screenPoint:(CGPoint)point scene3DPoint:(PLPosition)position {
    NSLog(@"hotspot.atv = %f, hotspot.ath = %f", hotspot.atv,hotspot.ath);

    
}

//从.bundle文件中 获取六方图 图片路径（6张图片）
- (NSArray *)getImagePathsWithBundleName:(NSString *)bundleName {
    //自定义的.bundle文件也存在与应用的主目录下，所以还是需要从主目录来拼接路径
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    if (!bundlePath) {
        [ZWAlertView showAlertWithViewController:self Message:@"图片资源不存在" Handler:^(UIAlertAction *handler) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    NSMutableArray *imagePaths = [NSMutableArray array];
    //六方图方位名称(按顺序来的)
        NSArray *imageNames = @[@"/Front.jpg", @"/Back.jpg", @"/Left.jpg", @"/Right.jpg", @"/Up.jpg", @"/Down.jpg"];
    for (NSInteger i = 0; i < imageNames.count; i++) {
        NSString *imagePath = [bundlePath stringByAppendingString:imageNames[i]];
        [imagePaths addObject:imagePath];
    }
    return [imagePaths copy];
}


#pragma mark -- getter
- (PLView *)plView {
    if (!_plView) {
        _plView = [[PLView alloc] initWithFrame:self.view.bounds];
        _plView.delegate = self;
        //惯性启动
        _plView.isInertiaEnabled = NO;
        //加速度计启用
        _plView.isAccelerometerEnabled = NO;
        //滚动启动
        _plView.isScrollingEnabled = NO;
        _plView.minDistanceToEnableScrolling = 50;

    }
    return _plView;
}



@end
