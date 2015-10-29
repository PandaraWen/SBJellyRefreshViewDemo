//
//  FMAnimation.m
//  Fami
//
//  Created by Pandara on 15/10/19.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import "SBAnimation.h"

@implementation SBAnimation

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
+ (CABasicAnimation *)rotationWithDuration:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration = dur;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
}

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
+ (CABasicAnimation *)translationWithDuration:(float)dur translate:(CGSize)translate autoReverse:(BOOL)autoReverse repeatCount:(int)repeatCount timingFunction:(FMAnimationTimingFunction)timingFunction
{
    NSString *timingFunctionName = [SBAnimation getTimingFunctionNameFromType:timingFunction];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.translation"];
    
    animation.toValue = [NSValue valueWithCGSize:translate];
    animation.duration = dur;
    animation.autoreverses = autoReverse;
    animation.cumulative = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    
    return animation;
}

#pragma mark - Toolkit
+ (NSString *)getTimingFunctionNameFromType:(FMAnimationTimingFunction)timingFunction
{
    NSString *functionName = @"";
    switch (timingFunction) {
        case FMAnimationTimingFunctionDefault:
            functionName = @"default";
            break;
        case FMAnimationTimingFunctionLinear:
            functionName = @"linear";
            break;
        case FMAnimationTimingFunctionEaseIn:
            functionName = @"easeIn";
            break;
        case FMAnimationTimingFunctionEaseOut:
            functionName = @"easeOut";
            break;
        case FMAnimationTimingFunctionEaseInOut:
            functionName = @"easeInEaseOut";
            break;
    }
    
    return functionName;
}

@end




















