//
//  UIView+HLLBadgeView.m
//  HLLBadge
//
//  Created by CouldHll on 14-6-30.
//  Copyright (c) 2014年 CouldHll. All rights reserved.
//

#import "UIView+HLLBadgeView.h"
#import <objc/runtime.h>

static const void *BadgeViewKey = &BadgeViewKey;

@implementation UIView(HLLBadgeView)

- (HLLBadgeView *)badgeView
{
    HLLBadgeView *_badgeView = objc_getAssociatedObject(self, BadgeViewKey);// for category
    if (_badgeView!=nil)
    {
        return _badgeView;
    }
    
    // create new
    HLLBadgeView *badgeView = [[HLLBadgeView alloc] initWithFrame:CGRectZero];
    self.badgeView = badgeView;
    return badgeView;
}

- (void)setBadgeView:(HLLBadgeView *)badgeView
{
    if (badgeView==nil)
    {
        [self.badgeView removeFromSuperview];
    }
    else
    {
        objc_setAssociatedObject(self, BadgeViewKey, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// for category
        [self addSubview:badgeView];
    }
}

@end
