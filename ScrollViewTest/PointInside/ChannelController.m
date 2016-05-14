//
//  ChannelController.m
//  TestDemo
//
//  Created by 李冬骜 on 15/9/10.
//  Copyright (c) 2015年 Dongao Li. All rights reserved.
//

#define margin 20
#define btnW ([UIScreen mainScreen].bounds.size.width - 20 * 4) / 3
#define defaultCount 9

#import "ChannelController.h"

@interface ChannelController ()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation ChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //九宫格
    UIView *contentView = [[UIView alloc] init];
    contentView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    for (int i = 0; i < defaultCount; i++) {
        [self addBtnWithIndex:i];
    }
}

/**
 *  添加
 */
- (IBAction)doAdd{
    NSInteger totalNum = self.contentView.subviews.count;
    NSInteger i = totalNum++;
    [self addBtnWithIndex:i];
}

- (void)addBtnWithIndex:(NSInteger)index{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnX = margin + (btnW + margin) * (index % 3);
    CGFloat btnY = (btnW + margin) * (index / 3);
    btn.frame = CGRectMake(btnX, btnY, btnW, btnW);
    btn.backgroundColor = [UIColor redColor];
    btn.tag = index;
    [btn setTitle:[NSString stringWithFormat:@"%ld", btn.tag + 1] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPress:)];
    [btn addGestureRecognizer:gr];
}

- (void)doDelete:(UIButton*)btn{
    //删除按钮
    [btn removeFromSuperview];
    [self viewMoveAnimFromIndex:btn.tag withoutIndex:self.contentView.subviews.count];
}

//从指定索引刷新frame动画
- (void)viewMoveAnimFromIndex:(NSInteger)from withoutIndex:(NSInteger)to{
    for (NSInteger i = from; i < self.contentView.subviews.count; i++) {
        UIButton *btn = self.contentView.subviews[i];
        btn.tag = i;
        [btn setTitle:[NSString stringWithFormat:@"%ld", btn.tag + 1] forState:UIControlStateNormal];
        if (i != to) { //不移动指定的btn
            CGFloat btnX = margin + (btnW + margin) * (i % 3);
            CGFloat btnY = (btnW + margin) * (i / 3);
            [UIView animateWithDuration:0.3 animations:^{
                btn.frame = CGRectMake(btnX, btnY, btnW, btnW);
            }];
        }
    }
}

//长按响应事件
- (void)btnLongPress:(UIGestureRecognizer *)recognizer{
    UIButton *recognizerView = (UIButton *)recognizer.view;
    // 长按视图在父视图中的位置（触摸点的位置）
    CGPoint recognizerPoint = [recognizer locationInView:self.contentView];
    if (recognizer.state == UIGestureRecognizerStateBegan) { //长按开始
        
        // 开始的时候改变拖动view的外观（放大，改变颜色等）
        [UIView animateWithDuration:0.2 animations:^{
            recognizerView.transform = CGAffineTransformMakeScale(1.3, 1.3);
            recognizerView.alpha = 0.7;
        }];
        // 把拖动view放到最上层
        [self.contentView bringSubviewToFront:recognizerView];
    } else if (recognizer.state == UIGestureRecognizerStateChanged){  //长按移动中
        
        recognizerView.center = recognizerPoint;
        for (UIButton *btn in self.contentView.subviews) {
            if (CGRectContainsPoint(btn.frame, recognizerView.center)&&btn!=recognizerView) {
                if (btn.tag > recognizerView.tag) {  //往后换
                    [self.contentView insertSubview:recognizerView aboveSubview:btn];
                    [self viewMoveAnimFromIndex:recognizerView.tag withoutIndex:btn.tag];
                    
                } else {  //往前换
                    [self.contentView insertSubview:recognizerView belowSubview:btn];
                    [self viewMoveAnimFromIndex:btn.tag withoutIndex:btn.tag];
                }
            }
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded){  //长按结束
        // 结束时候恢复view的外观（放大，改变颜色等）
        [UIView animateWithDuration:0.2 animations:^{
            recognizerView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            recognizerView.alpha = 1;
            [self viewMoveAnimFromIndex:recognizerView.tag withoutIndex:self.contentView.subviews.count];
        }];
    }
}

@end
