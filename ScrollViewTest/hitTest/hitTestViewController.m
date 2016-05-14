//
//  ViewController.m
//  hitTest
//
//  Created by 李冬骜 on 5/11/16.
//  Copyright © 2016 Dongao Li. All rights reserved.
//

#import "hitTestViewController.h"

@interface hitTestViewController ()
@property (weak, nonatomic) IBOutlet UIImageView* imgView;

@end

@implementation hitTestViewController
- (IBAction)btnClick:(id)sender
{
    NSLog(@"button click");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:btn];
}

@end
