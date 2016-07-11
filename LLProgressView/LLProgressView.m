//
//  LLProgressView.m
//
//  Created by linl on 16/7/8.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import "LLProgressView.h"

@interface LLProgressView ()
{
    CAShapeLayer *shapeLayer;           //圆弧图层
    CAShapeLayer *shapeLayerGou;        //对勾图层
    
    CGFloat view_w;                     //控件宽度
    CGPoint center;                     //圆心
    float radius;                       //半径
}

@property (nonatomic, strong) CABasicAnimation *animation;

@end

@implementation LLProgressView

#pragma mark life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        view_w = self.frame.size.width;
        [self initViews];
    }
    return self;
}

#pragma mark - 私有方法

/**
 *  初始化圆圈
 */
- (void)initViews
{
    /**
     *  例子self.frame.size.width = 26
     */
    //圆圈路径
    center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);//圆心
    radius = (view_w - 3)/2;//半径
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle:M_PI/2 clockwise:YES];//顺时针绘制
    path.lineCapStyle = kCGLineCapRound; //线条拐角
    path.lineJoinStyle = kCGLineCapRound; //终点处理
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;//线条颜色
    shapeLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色
    shapeLayer.lineWidth = 2.0;
    shapeLayer.strokeStart = 0.0;
    shapeLayer.strokeEnd = 1.0;
    [self.layer addSublayer:shapeLayer];
    
    
}

/**
 *  圆弧隐藏动画
 */
- (void)startCircleHideAnimation
{
    CABasicAnimation *animHide = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animHide setFromValue:@1.0];
    [animHide setToValue:@0.0];
    [animHide setDuration:1];
    animHide.beginTime = 0.0;
    animHide.removedOnCompletion = NO;
    animHide.fillMode = kCAFillModeForwards;//当动画结束后,layer会一直保持着动画最后的状态
    animHide.delegate = self;
    [shapeLayer addAnimation:animHide forKey:@"CircleHide"];
}

/**
 *  开始对勾动画
 */
- (void)startGouAnimation
{
    if (shapeLayerGou) {
        shapeLayerGou.hidden = NO;
    } else {
        //对勾路径
        CGFloat offset = radius/2;
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        linePath.lineCapStyle = kCGLineCapRound; //线条拐角
        linePath.lineJoinStyle = kCGLineCapRound; //终点处理
        [linePath moveToPoint:CGPointMake(center.x - radius, center.y - 1)];
        [linePath addLineToPoint:CGPointMake(center.x - offset, center.y + (offset - 1))];
        [linePath addLineToPoint:CGPointMake(center.x + offset, center.y - offset)];
        
        shapeLayerGou = [CAShapeLayer layer];
        shapeLayerGou.path = linePath.CGPath;
        shapeLayerGou.strokeColor = [UIColor greenColor].CGColor;//线条颜色
        shapeLayerGou.fillColor = [UIColor clearColor].CGColor;//填充颜色
        shapeLayerGou.lineWidth = 2.0;
        shapeLayerGou.strokeStart = 0.0;
        shapeLayerGou.strokeEnd = 0.0;
        [self.layer addSublayer:shapeLayerGou];
    }
    
    CABasicAnimation *animGou = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animGou.fromValue = @0.0;
    animGou.toValue = @1.0;
    animGou.duration = 1.0;
    animGou.beginTime = 0.0;
    animGou.removedOnCompletion = NO;
    animGou.fillMode = kCAFillModeForwards;
    animGou.delegate = self;
    [shapeLayerGou addAnimation:animGou forKey:@"gou"];
}

/**
 *  移除动画
 */
- (void)removeAnimation
{
    if (shapeLayerGou) {
        shapeLayerGou.hidden = YES;
        [shapeLayer removeAllAnimations];
    }
    [self.layer removeAllAnimations];
    self.isCircleStop = NO;
}

#pragma mark - 公有方法

/**
 *  开始整个动画
 *
 *  @param block 动画完成回调block
 */
- (void)startCircleAnimation:(AnimStopBlock)block
{
    self.stopBlock = block;
    if (shapeLayerGou) {
        shapeLayerGou.hidden = YES;
    }
    //外层旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0.0;
    rotationAnimation.toValue = @(-2*M_PI);
    rotationAnimation.repeatCount = 1;
    rotationAnimation.duration = 1.0;
    rotationAnimation.beginTime = 0.0;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = YES;
    [rotationAnimation setValue:@"successStep1" forKey:@"Circle"];
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma -mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"Circle"] isEqualToString:@"successStep1"]) {
        if (self.isCircleStop) {
            //耗时方法结束则执行对勾动画
            [self startCircleHideAnimation];
            [self startGouAnimation];
        } else {
            //未结束则循环动画
            [self startCircleAnimation:self.stopBlock];
        }
    } else {
        if (self.stopBlock) {
            self.stopBlock(flag);
            //两秒后移除所有动画
            [self performSelector:@selector(removeAnimation) withObject:self afterDelay:2.0];
        }
    }
    
}



@end
