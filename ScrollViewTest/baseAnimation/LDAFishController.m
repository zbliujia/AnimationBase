//
//  LDAFishController.m
//  Fish
//
//  Created by 李冬骜 on 15/01/21.
//  Copyright © 2015年 Dongao Li. All rights reserved.
//

#import "LDAFishController.h"

@interface LDAFishController ()

@property (weak, nonatomic) UIImageView* fishView;

@end

@implementation LDAFishController

- (void)loadView
{
    [super loadView];
    self.view.userInteractionEnabled = YES;
    self.btn.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"bg"].CGImage);

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40, 450, 80, 60)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"开始" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fishStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.enabled = YES;
    self.btn = btn;

    UIImageView* fishView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.3, 100, 0, 0)];
    fishView.image = [UIImage imageNamed:@"fish0"];
    [fishView sizeToFit];
    [self.view addSubview:fishView];

    //  创建鱼的图片的数组
    NSMutableArray* imageArray = [NSMutableArray array];
    //  循环添加10个鱼的图片
    for (int i = 0; i < 10; i++) {
        NSString* imageName = [NSString stringWithFormat:@"fish%d", i];
        UIImage* image = [UIImage imageNamed:imageName];
        [imageArray addObject:image];
    }
    fishView.animationImages = imageArray;
    fishView.animationDuration = 1;
    [fishView startAnimating];

    self.fishView = fishView;
}

- (void)fishStart
{
    // 1.创建对象
    CAAnimationGroup* group = [[CAAnimationGroup alloc] init];

    // *1.创建一个基本动画 (自旋转)
    // 1.创建基本动画的对象
    CABasicAnimation* anim = [[CABasicAnimation alloc] init];

    // 2.基本动画的操作
    anim.keyPath = @"transform.rotation"; // 修改哪一个属性
    // byValue
    anim.byValue = @(-2 * M_PI); // 累加

    // *2.创建一个关键帧动画 (绕着圆跑)
    // 1.创建动画对象
    CAKeyframeAnimation* animSelf = [[CAKeyframeAnimation alloc] init];

    // 2.动画的操作
    animSelf.keyPath = @"position";
//    animSelf.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.25 :0.5 :0.75 :1];

    // path
//    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.fishView.center.x, self.fishView.center.y + 130) radius:130 startAngle:-M_PI_2 endAngle:-5 * M_PI_2 clockwise:0];
    animSelf.path = path.CGPath;

    // 2.操作
    group.animations = @[ anim, animSelf ];

    // 设置时间
    group.duration = 5;
    group.repeatCount = INT_MAX;

    // 3.添加到layer上
    if (![self.fishView.layer animationForKey:@"fish"]) {
        [self.fishView.layer addAnimation:group forKey:@"fish"];
    }
}

@end
