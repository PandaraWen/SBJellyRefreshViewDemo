//
//  SBJellyRefreshView.h
//  SBJellyRefreshViewDemo
//
//  Created by Pandara on 15/10/28.
//  Copyright © 2015年 Pandara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJellyBall.h"
#import "SBDefine.h"

@class SBJellyRefreshView;
@protocol SBJellyRefreshViewDelegate <NSObject>

@optional
- (void)sbJellyRefreshVieWillStartRefresh:(SBJellyRefreshView *)refreshView;

@end

@interface SBJellyRefreshView : UIView

@property (weak, nonatomic) id <SBJellyRefreshViewDelegate> delegate;

+ (SBJellyRefreshView *)getRefreshView;
- (void)pullToDistance:(CGFloat)distance;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDragging;
- (void)endRefresh;
@end
