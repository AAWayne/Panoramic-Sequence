//
//  ZWSpinImageView.m
//  zhiweism
//
//  Created by Candy on 2017/5/24.
//  Copyright © 2017年 zhiweism. All rights reserved.
//

#import "ZWSpinImageView.h"
#import "ZWAlertView.h"
@interface ZWSpinImageView () <ZWSpinImageViewDelegate, ZWSpinImageViewDatasource, UIGestureRecognizerDelegate> {
    NSTimer     *_timer;
}

@property (nonatomic, assign) NSInteger imageCount;
@property (nonatomic, assign) CGPoint   touchPoint;
@property (nonatomic, assign) NSInteger touchIndex;

//手势
@property (nonatomic, strong)   UIPanGestureRecognizer          *   panGesture;
@property (nonatomic, strong)   UITapGestureRecognizer          *   tapGesture;

@end

@implementation ZWSpinImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:self.imageView];
        //手势大小
        _panDistance = 60;
        
        //添加拖移手势
        [self addGestureRecognizer:self.panGesture];
        
        //添加点击手势
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

#pragma mark -- action
//向前移动
- (void)moveForward {
    NSInteger index = self.currentIndex;
    index += 1;
    if (index > self.imageCount - 1) {
        if (!self.isRepeat) {
            [self stopMove];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertPrompt" object:nil userInfo:@{@"moveForward":@(YES)}];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"StopAutoMove" object:nil userInfo:nil];
        }
    }
    //是否重复（循环展示）
    if (self.isRepeat) {
        self.currentIndex = index >= self.imageCount ? 0 : index;//这句话是让走完之后重头再来
    } else {
        self.currentIndex = index >= self.imageCount ? self.imageCount - 1 : index;
    }
    
}

//向后移动
- (void)moveBack {
    NSInteger index = self.currentIndex;
    index -= 1;
    if (index < 0) {
        [self stopMove];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertPrompt" object:nil userInfo:@{@"moveBack":@(YES)}];
    }
    //是否重复（循环展示）
    if (self.isRepeat) {
        self.currentIndex = index < 0 ? self.imageCount - 1 : index;//这句话是让走完之后重头再来
    } else {
        self.currentIndex = index < 0 ? 0 : index;
    }
}

//自动前进
- (void)autoMoveForward {
    [self stopTimer];
    double timeInterval = 0.1;
    if (_timeInterval) {
        timeInterval = _timeInterval;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(moveForward) userInfo:nil repeats:YES];
    [self removeGestureRecognizer:_panGesture];
    self.panGesture.delegate = nil;
}

//自动后退
- (void)autoMoveBack {
    [self stopTimer];
    double timeInterval = 0.1;
    if (_timeInterval) {
        timeInterval = _timeInterval;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(moveBack) userInfo:nil repeats:YES];
    [self removeGestureRecognizer:_panGesture];
    self.panGesture.delegate = nil;
}

//停止移动
- (void)stopMove {
    [self stopTimer];
    self.panGesture.delegate = self;
    [self addGestureRecognizer:_panGesture];
}

//移除定时器
- (void)stopTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (self.dataSource) {
        _currentIndex = currentIndex;
        self.imageView.image = (currentIndex >= self.imageCount) ? nil : [self.dataSource spinImageView:self imageAtIndex:currentIndex];
    }
    else {
        _currentIndex = 0;
    }
    
}

- (UIImage *)currentImage {
    if (self.dataSource) {
        return [self.dataSource spinImageView:self imageAtIndex:self.currentIndex];
    }
    
    return nil;
}

- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    if (!_imagesArray) {
        [self.delegate spinImageViewFailedLoadData:self];
        return;
    }
    [self.delegate spinImageViewBeginLoadData:self];
    self.dataSource = self;
    [self reloadData];
    [self.delegate spinImageViewEndLoadData:self];

    
}

#pragma mark --  loadData

- (void)reloadData {
    if (self.dataSource) {
        self.imageCount = [self.dataSource numberOfViewsInspinImageView:self];
        self.currentIndex = 0;
    }
    
}

#pragma mark --  dataSource

- (UIImage *)spinImageView:(ZWSpinImageView *)view imageAtIndex:(NSInteger)index {
    return [UIImage imageWithContentsOfFile:self.imagesArray[index]];
}

- (NSInteger)numberOfViewsInspinImageView:(ZWSpinImageView *)spinImageView {
    return self.imagesArray.count;
}

#pragma mark --  gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return self.imageCount > 1;
    }
    
    if ( [gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
        return self.imageCount > 0;
    }
    return NO;
}

//拖移手势事件
- (void)actionPan:(UIPanGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            self.touchIndex = self.currentIndex;
            self.touchPoint = [gesture locationInView:self];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint pt = [gesture locationInView:self];
            double offset = pt.x - self.touchPoint.x;
            
            NSInteger index = (int)(((offset+self.panDistance/2.0f) + (1000*self.panDistance) )/ self.panDistance) - 1000 + self.touchIndex;
            if (!self.isRepeat) {
                //Modify By Candy -- 此处的if判断是我后来添加的  当下标超过图片数量或小于0的时候，就停止前进或者后退------start-----
                if (index >= self.imageCount) {
                    //至于停止后要做什么操作提示什么的都在这儿处理，我这里使用的是通知当前界面弹出提示
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertPrompt" object:nil userInfo:@{@"moveForward":@(YES)}];
                    return;
                }
                if (index < 0){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertPrompt" object:nil userInfo:@{@"moveBack":@(YES)}];
                    return;
                }
            }
            // -----------------------------------end--------------------------------------------

            if ( index != self.currentIndex ) {
                self.currentIndex = (index + self.imageCount*1000) % self.imageCount;
            }
            break;
        }
            
        default:
            break;
    }
}

//点击手势事件
- (void)actionTap:(UITapGestureRecognizer *)gesture {
    if ( [self.delegate respondsToSelector:@selector(spinImageView:didSelectAtIndex:)] ) {
        [self.delegate spinImageView:self didSelectAtIndex:self.currentIndex];
    }
}

#pragma mark -- getter

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPan:)];
        _panGesture.maximumNumberOfTouches = 1;
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)];
        _tapGesture.delegate = self;
    }
    return _tapGesture;
}





@end
