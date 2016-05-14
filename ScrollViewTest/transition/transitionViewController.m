//
//  transitionViewController.m
//  CATransition
//
//  Created by 李冬骜 on 15/01/13.
//  Copyright (c) 2015年 Dongao Li. All rights reserved.
//

#import "transitionViewController.h"

@interface transitionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView* imageView;
@property (assign, nonatomic) int imageNameIndex;

@end

@implementation transitionViewController

// 手指清扫 调用
- (IBAction)swipe:(UISwipeGestureRecognizer*)sender
{
    self.imageNameIndex++;

    if (self.imageNameIndex > 5) {
        self.imageNameIndex = 1;
    }

    // 创建转场动画的对象
    CATransition* anim = [[CATransition alloc] init];
    // 操作

    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        anim.type = @"rippleEffect";

        anim.subtype = kCATransitionFromRight;
        // 从右往左滑
        NSLog(@"left");

        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", self.imageNameIndex]];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        anim.type = @"suckEffect";
        
        anim.subtype = kCATransitionFromBottom;
        // 从下往上滑
        NSLog(@"up");
        
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", self.imageNameIndex]];
    } else if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        anim.type = @"cameraIrisHollowOpen";
        
        anim.subtype = kCATransitionFromTop;
        // 从上往下滑
        NSLog(@"down");
        
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", self.imageNameIndex]];
    } else {
        anim.type = @"cube";
        
        // 方向
        anim.subtype = kCATransitionFromLeft;

        // 从左往右滑
        NSLog(@"right");
        self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", self.imageNameIndex]];
    }

    // 添加到
    [self.imageView.layer addAnimation:anim forKey:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageNameIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
