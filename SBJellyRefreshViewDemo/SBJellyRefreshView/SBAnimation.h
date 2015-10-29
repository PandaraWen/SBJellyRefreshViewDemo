//
//  FMAnimation.h
//  Fami
//
//  Created by Pandara on 15/10/19.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FMAnimationTimingFunction) {
    FMAnimationTimingFunctionDefault,
    FMAnimationTimingFunctionLinear,
    FMAnimationTimingFunctionEaseIn,
    FMAnimationTimingFunctionEaseOut,
    FMAnimationTimingFunctionEaseInOut,
};

@interface SBAnimation : NSObject

/**
 *  旋转
 *
 *  @param dur         旋转时间
 *  @param degree      旋转角度（不用M_PI这些）
 *  @param direction   方向（1为顺时针，-1为逆时针）
 *  @param repeatCount 重复次数
 *
 *  @return CABasicAnimation
 */
+ (CABasicAnimation *)rotationWithDuration:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount;

/**
 *  位移
 *
 *  @param dur            位移时间
 *  @param translate      位移距离，用 size 表征
 *  @param autoReverse    自动反向
 *  @param repeatCount    重复次数
 *  @param timingFunction 时间函数
 *
 *  @return CABasicAnimation
 */
+ (CABasicAnimation *)translationWithDuration:(float)dur translate:(CGSize)translate autoReverse:(BOOL)autoReverse repeatCount:(int)repeatCount timingFunction:(FMAnimationTimingFunction)timingFunction;



@end
