# SBJellyRefreshViewDemo
---
A simple and beautiful stretch pull-to-refresh view for iOS, developed in obj-c，refering to [KYJellyPullToRefresh](https://github.com/KittenYang/KYJellyPullToRefresh)

![image](http://7ls0ue.com1.z0.glb.clouddn.com/2015/10/27/sbjellyrefresh/demo3.gif)

## Requirements

SBJellyRefreshView works on iOS 7.0 and later version. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework

## Usage

Copy the SBJellyRefreshView folder to your project, then

**1. Initalize**
```objective-c
self.refreshView = [SBJellyRefreshView getRefreshView];
self.refreshView.delegate = self;
self.refreshView.center = CGPointMake(self.refreshView.frame.size.width / 2.0f, -self.refreshView.frame.size.height / 2.0f);
[self.tableView addSubview:self.refreshView];
```

**2. UIScrollViewDelegate in the viewController that retain self.tableView**
```objective-c
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshView scrollViewDidEndDragging];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}
```

**3. Implement the SBJellyRefreshViewDelegate**
```objective-c
- (void)sbJellyRefreshVieWillStartRefresh:(SBJellyRefreshView *)refreshView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshView endRefresh];
    });
}
```

That's all. You can find more detail in ViewController.m contained in this demo.


## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## SpecialThanks
[@KittenYang](https://github.com/KittenYang/KYGooeyMenu)  KYJellyPullToRefresh

