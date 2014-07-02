//
//  HLLViewController.m
//  HLLBadgeViewDemo
//
//  Created by CouldHll on 14-7-2.
//  Copyright (c) 2014年 CouldHll. All rights reserved.
//

#import "HLLViewController.h"
#import "UIView+HLLBadgeView.h"

@interface HLLViewController ()

@end

@implementation HLLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 250, 50)];
    view1.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view1];
    view1.badgeView.text = @"9";
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 150, 250, 50)];
    button1.backgroundColor = [UIColor blackColor];
    [button1 setTitle:@"Click me to remove badge" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(toggleBadge:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    HLLBadgeView *buttonBadgeView1=[[HLLBadgeView alloc] init];
    buttonBadgeView1.text = @"hello";
    buttonBadgeView1.cornerRadius=5;
    buttonBadgeView1.horizontalAlignment=HLLBadgeViewHorizontalAlignmentLeft;
    buttonBadgeView1.borderWidth = 2.0;
    buttonBadgeView1.borderColor = [UIColor blueColor];
    button1.badgeView=buttonBadgeView1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toggleBadge:(id)sender
{
    UIView *view = (UIButton*)sender;
    view.badgeView=nil;
}

@end
