//
//  SBJellyRefreshView.m
//  SBJellyRefreshViewDemo
//
//  Created by Pandara on 15/10/28.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import "SBJellyRefreshView.h"
#import "SBAnimation.h"

#define KEY_ANIMATION_BALL_ROTATION @"ballrotation"

#define REFRESH_H 80
#define BALL_W 20

#define COLLISION_BOUNDARY_BEZIER @"bezier"
#define BALLCENTER_INIT CGPointMake(BALL_W / 2.0f + 40, self.frame.size.height - 100)

@interface SBJellyRefreshView() {
    BOOL _toRefresh;
}

@property (weak, nonatomic) UIScrollView *parentScrollView;

@property (strong, nonatomic) SBJellyBall *ball;

@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIBezierPath *bezierPath;
@property (strong, nonatomic) UIDynamicItemBehavior *ballBehavior;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation SBJellyRefreshView

+ (SBJellyRefreshView *)getRefreshView
{
    SBJellyRefreshView *refreshView = [[SBJellyRefreshView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height)];
    return refreshView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.fillColor = MIDNIGHT_COLOR.CGColor;
        self.shapeLayer.anchorPoint = CGPointMake(0, 0);
        self.shapeLayer.position = CGPointMake(0, 0);
        self.shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:self.shapeLayer];
        
        self.bezierPath = [self getPathFromDistance:0];
        self.shapeLayer.path = self.bezierPath.CGPath;
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        //ball
        self.ball = [[SBJellyBall alloc] initWithFrame:CGRectMake(0, 0, BALL_W, BALL_W)];
        self.ball.center = BALLCENTER_INIT;
        [self addSubview:self.ball];
        
        //gravity
        self.gravityBehavior = [[UIGravityBehavior alloc] init];
        [self.animator addBehavior:self.gravityBehavior];
        
        //collision
        self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.ball]];
        self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
        [self.collisionBehavior addBoundaryWithIdentifier:COLLISION_BOUNDARY_BEZIER forPath:self.bezierPath];
        [self.animator addBehavior:self.collisionBehavior];
        
        //ball property
        self.ballBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
        self.ballBehavior.elasticity = 0.4;
        self.ballBehavior.allowsRotation = YES;
        self.ballBehavior.friction = 1;
        self.ballBehavior.angularResistance = 0.5;
        self.ballBehavior.resistance = 0.5;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    UIView *superView = self.superview;
    while (superView) {
        if ([superView isKindOfClass:[UIScrollView class]]) {
            self.parentScrollView = (UIScrollView *)superView;
            break;
        } else {
            superView = superView.superview;
        }
    }
}

- (UIBezierPath *)getPathFromDistance:(CGFloat)Distance
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
    [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
    [bezierPath addQuadCurveToPoint:CGPointMake(0, self.frame.size.height) controlPoint:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height + Distance)];
    [bezierPath closePath];
    
    return bezierPath;
}


- (void)pullToDistance:(CGFloat)distance
{
    //toRefresh为Yes时，distance有可能取到负值，因为
    //scrollViewDidScroll中distance -= REFRESH_H;
    if (distance < 0) {
        return;
    }
    
    //下拉时小球受重力作用，复位时小球也复位
    if (!_toRefresh) {
        if (distance > FLOAT_TRESHOLD) {
            if (![self.gravityBehavior.items containsObject:self.ball]) {
                [self.gravityBehavior addItem:self.ball];
                self.ballBehavior.resistance = 0.5;
                self.ballBehavior.angularResistance = 0.5;
            }
            
            //refersh的时候ballBehavior会被移除，故此处需要检测
            if (![self.animator.behaviors containsObject:self.ballBehavior]) {
                [self.animator addBehavior:self.ballBehavior];
            }
            
            //refresh的时候碰撞会被移除，故此处需要检测
            if (![self.collisionBehavior.items containsObject:self.ball]) {
                [self.collisionBehavior addItem:self.ball];
            }
        } else {
            [self resetBallIfNeeded];
        }
    }
   
    
    //弧形边界
    self.bezierPath = [self getPathFromDistance:distance];
    
    [self.collisionBehavior removeBoundaryWithIdentifier:COLLISION_BOUNDARY_BEZIER];
    [self.collisionBehavior addBoundaryWithIdentifier:COLLISION_BOUNDARY_BEZIER forPath:self.bezierPath];
    
    self.shapeLayer.path = self.bezierPath.CGPath;
    
    //如果小球漏出去了，拉它回来
    if (!_toRefresh) {
        [self dragBallBackIfNeeded];
    }
}

/**
 *  条件成立时重置ball相关
 */
- (void)resetBallIfNeeded
{
    if (!_toRefresh && [self.gravityBehavior.items containsObject:self.ball]) {
        [self.gravityBehavior removeItem:self.ball];
        [self resetBallPosition];
        
        self.ballBehavior.angularResistance = 1000;
        self.ballBehavior.resistance = 1000;
    }
}

/**
 *  仅设置Ball的position
 */
- (void)resetBallPosition
{
    self.ball.center = BALLCENTER_INIT;
    [self.animator updateItemUsingCurrentState:self.ball];
}

- (void)dragBallBackIfNeeded
{
    if (![self.bezierPath containsPoint:self.ball.center]) {
        self.ball.center = CGPointMake(self.ball.center.x, self.ball.center.y - BALL_W);
        [self.animator updateItemUsingCurrentState:self.ball];
    }
}

- (void)startBallAnimation
{
    [UIView animateWithDuration:0.1f animations:^{
        self.ball.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height - REFRESH_H + 20 + BALL_W / 2.0f);
    } completion:^(BOOL finished) {
        CABasicAnimation *animation = [SBAnimation rotationWithDuration:0.2f degree:360 direction:1 repeatCount:INT_MAX];
        self.ball.transform = CGAffineTransformMakeRotation(0);//不加这句代码旋转会卡顿
        [self.ball.layer addAnimation:animation forKey:KEY_ANIMATION_BALL_ROTATION];
    }];
}

#pragma mark - Method
- (void)scrollViewDidScroll
{
    if (!self.parentScrollView) {
        return;
    }
    
    if (self.parentScrollView.contentOffset.y > 0) {
        [self resetBallIfNeeded];
        return;
    }
    
    CGFloat distance = -self.parentScrollView.contentOffset.y;
    
    //设置scrollView相关
    if (_toRefresh) {
        distance -= REFRESH_H;
        if (self.parentScrollView.contentOffset.y >= -REFRESH_H && self.parentScrollView.contentInset.top == 0) {
            self.parentScrollView.contentInset = UIEdgeInsetsMake(REFRESH_H, 0, 0, 0);
            self.parentScrollView.contentOffset = CGPointMake(0, -REFRESH_H);
        }
    }
    
    //设置弧形layer
    [self pullToDistance:distance];
}

- (void)scrollViewDidEndDragging
{
    [self dragBallBackIfNeeded];
    
    if (_toRefresh == NO && -self.parentScrollView.contentOffset.y >= REFRESH_H) {
        _toRefresh = YES;
        
        [self.gravityBehavior removeItem:self.ball];
        [self.animator removeBehavior:self.ballBehavior];
        [self.collisionBehavior removeItem:self.ball];
        
        [self startBallAnimation];
        
        if ([_delegate respondsToSelector:@selector(sbJellyRefreshVieWillStartRefresh:)]) {
            [_delegate sbJellyRefreshVieWillStartRefresh:self];
        }
    }
}

- (void)endRefresh
{
    _toRefresh = NO;
    [UIView animateWithDuration:0.1f animations:^{
        self.parentScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self resetBallPosition];
    }];
    [self.ball.layer removeAnimationForKey:KEY_ANIMATION_BALL_ROTATION];
}

@end






















