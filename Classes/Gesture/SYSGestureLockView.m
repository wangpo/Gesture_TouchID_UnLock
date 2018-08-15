//
//  SYSGestureLockView.m
//   Demo
//
//  Created by wangpo on 2018/7/31.
//  Copyright © 2018年 王坡. All rights reserved.
//

#import "SYSGestureLockView.h"

@interface SYSGestureLockView ()

@property (nonatomic, strong) NSMutableArray *selectBtns;//选择的点
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation SYSGestureLockView

#pragma mark - getter
- (NSMutableArray *)selectBtns {
    if (!_selectBtns) {
        _selectBtns = [NSMutableArray array];
    }
    return _selectBtns;
}

#pragma mark - initializer
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

// 子视图初始化
- (void)initSubviews {
    self.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    // 创建九宫格 9个按钮
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.tag = i + 1;
    }
}

//子类重写该方法，只调要用这个方法，就表示父控件的尺寸确定，改变大小，addSubview等都会出发
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    
    int cols = 3;//总列数
    
    CGFloat x = 0,y = 0,w = 60,h = 60;
    
    CGFloat margin = (self.bounds.size.width - cols * w - 28*2) / 2;//间距
    
    CGFloat col = 0;
    CGFloat row = 0;
    for (int i = 0; i < count; i++) {
        
        col = i % cols;
        row = i / cols;
        
        x = margin + (w+28)*col;
        y = (w+28)*row;
        
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
        if (self.hiddenGestureTrack) {
            [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateSelected];
        }else{
            [btn setImage:[UIImage imageNamed:@"gesture_select"] forState:UIControlStateSelected];
        }
        
    }
}

// 只要调用这个方法就会把之前绘制的东西清空 重新绘制
- (void)drawRect:(CGRect)rect {
    if (_selectBtns.count == 0) return;
    //校验密码时，区分是否显示路径
    if (self.hiddenGestureTrack) {
        return;
    }
    // 把所有选中按钮中心点连线
    UIBezierPath *path = [UIBezierPath bezierPath];

    for (int i = 0; i < self.selectBtns.count; i ++) {
        UIButton *btn = self.selectBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center]; // 设置起点
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint];
    
    [UIColorFromRGB(0x08A3EE) set];
    //设置路径属性
    path.lineWidth = 1;
    path.lineJoinStyle = kCGLineJoinRound;//交叉点
    path.lineCapStyle = kCGLineCapRound;//终点
    //渲染
    [path stroke];
}

#pragma mark - action pan
- (void)pan:(UIPanGestureRecognizer *)pan {
    _currentPoint = [pan locationInView:self];
    [self setNeedsDisplay];//setNeedsDisplay会自动调用drawRect方法
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectBtns addObject:button];
        }
    }
    //[self setNeedsLayout];//setNeedsLayout标记为需要重新布局，不立即刷新，但layoutSubviews一定会被调用
    //[self layoutIfNeeded]; //layoutIfNeeded在需要重新布局的时候立即刷新进行重新布局
    if (pan.state == UIGestureRecognizerStateEnded) {
        // 保存输入密码
        // 注意：我们在密码判定过程中是通过根据先前布局按钮的时候定义的按钮tag值进行字符串拼接，密码传值是通过代理实现。
        NSMutableString *gesturePwd = @"".mutableCopy;
        for (UIButton *button in self.selectBtns) {
            [gesturePwd appendFormat:@"%ld",button.tag-1];
            button.selected = NO;
        }
        [self.selectBtns removeAllObjects];
        // 手势密码绘制完成后回调
        if ([self.delegate respondsToSelector:@selector(gestureLockView:drawRectFinished:)]) {
            [self.delegate gestureLockView:self drawRectFinished:gesturePwd];
        }
        
    }
}

@end
