//
//  SBJellyBall.m
//  SBJellyRefreshViewDemo
//
//  Created by Pandara on 15/10/28.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import "SBJellyBall.h"
#import "SBDefine.h"

@implementation SBJellyBall

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat elementW = frame.size.width / 2.0f;
        CGFloat elementH = frame.size.height / 2.0f;
        
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, elementW, elementH)];
        redView.backgroundColor = RED_COLOR;
        [self addSubview:redView];
        
        UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(elementW, 0, elementW, elementH)];
        yellowView.backgroundColor = YELLOW_COLOR;
        [self addSubview:yellowView];
        
        UIView *buleView = [[UIView alloc] initWithFrame:CGRectMake(0, elementH, elementW, elementH)];
        buleView.backgroundColor = BULE_COLOR;
        [self addSubview:buleView];
        
        UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(elementW, elementH, elementW, elementH)];
        greenView.backgroundColor = GREEN_COLOR;
        [self addSubview:greenView];
        
        
        self.layer.cornerRadius = frame.size.width / 2.0f;
        self.clipsToBounds = YES;
    }
    
    return self;
}

#pragma mark - Propertys in UIDynamicItem
- (UIDynamicItemCollisionBoundsType)collisionBoundsType
{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
