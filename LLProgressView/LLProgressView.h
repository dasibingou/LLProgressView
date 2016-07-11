//
//  LLProgressView.h
//
//  Created by linl on 16/7/8.
//  Copyright © 2016年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnimStopBlock)(BOOL isFinish);

@interface LLProgressView : UIView

/**
 *  动画完成回调block
 */
@property (nonatomic, copy) AnimStopBlock stopBlock;

/**
 *  圆弧动画是否停止标示，即判断耗时方法是否结束
 */
@property (nonatomic, assign) BOOL isCircleStop;

/**
 *  开始整个动画
 *
 *  @param block 动画完成回调block
 */
- (void)startCircleAnimation:(AnimStopBlock)block;

@end
