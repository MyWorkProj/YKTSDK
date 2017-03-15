//
//  YKTLoadingView.m
//  yktw
//
//  Created by wangyong on 2016/11/1.
//  Copyright © 2016年 yiketong. All rights reserved.
//

#import "YKTLoadingView.h"

@interface YKTLoadingView ()
{
    UIActivityIndicatorView *_activity;
}

@end


@implementation YKTLoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center = self.center;
        [self addSubview:_activity];
    }
    return self;
}


- (void)showView {
    [_activity startAnimating];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    [window bringSubviewToFront:self];
}

- (void)dismissView {
    [_activity stopAnimating];
    [self removeFromSuperview];
}

@end
