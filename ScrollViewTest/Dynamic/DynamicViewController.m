//
//  DynamicViewController.m
//  Dynamic
//
//  Created by 李冬骜 on 15/7/16.
//  Copyright (c) 2015年 Dongao Li. All rights reserved.
//

#import "DynamicViewController.h"

@interface DynamicViewController ()
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

@implementation DynamicViewController

#pragma mark 懒加载仿真器
- (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        //1. 创建仿真器
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

//    [self gravityAndCollisionClick];
    
    //2. 移除之前的仿真行为
    [self.animator removeAllBehaviors];
    
    //3. 获取点击的点
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    //4. 创建仿真行为
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.redView snapToPoint:point];
    
    //4.1 减震
    snap.damping = 0.9;
    
    //5. 行为添加进去
    [self.animator addBehavior:snap];
}

- (void)gravityAndCollisionClick {
    
    //2. 创建仿真行为
    //2.1 添加重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.redView ]];
    
    //2.1.1
    // 重力方向（是一个角度，以x轴正方向为0°，顺时针正数，逆时针负数）
    //    gravity.angle = M_PI_2;
    // 量级（用来控制加速度，1.0代表加速度是1000 points /second²）
    //    gravity.magnitude = 20;
    // 重力方向（是一个二维向量）
    gravity.gravityDirection = CGVectorMake(1, 3);
    
    //2.2 添加碰撞
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.redView, self.blueView]];
    
    //2.2.1 设置边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
//
//    //2.2.2
//    CGPoint from = CGPointMake(0, self.view.frame.size.height * 0.2);
//    CGPoint to = CGPointMake(CGRectGetMaxX(self.view.frame), self.view.frame.size.height * 0.7);
//    
//    [collision addBoundaryWithIdentifier:@"line" fromPoint:from toPoint:to];
//    
//    //2.2.3
//    UIBezierPath *bezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
//    [collision addBoundaryWithIdentifier:@"bezier" forPath:bezier];
    
    //3. 行为添加进去
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

@end
