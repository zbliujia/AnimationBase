//
//  TigerViewController.m
//  tiger机
//
//  Created by 李冬骜 on 15/10/28.
//  Copyright © 2015年 Dongao Li. All rights reserved.
//

#import "TigerViewController.h"

@interface TigerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel* label1;
@property (weak, nonatomic) IBOutlet UILabel* label2;
@property (weak, nonatomic) IBOutlet UILabel* label3;
@property (weak, nonatomic) IBOutlet UIPickerView* luckyPickerView;
@property (weak, nonatomic) IBOutlet UIButton* clickBtn;

@property (strong, nonatomic) NSOperationQueue* queue;

@end

@implementation TigerViewController

- (NSOperationQueue*)queue
{
    if (nil == _queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (IBAction)didClickBtn:(UIButton*)sender
{

    if (self.queue.operationCount == 0) {
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
        [self.queue setSuspended:NO];
        NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^{
            [self random];
        }];
        [self.queue addOperation:op];
    }
    else {
        [sender setTitle:@"继续" forState:UIControlStateNormal];
        [self.queue setSuspended:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.clickBtn setTitle:@"开始" forState:UIControlStateNormal];
    self.label1.hidden = YES;
    self.label2.hidden = YES;
    self.label3.hidden = YES;
    self.luckyPickerView.userInteractionEnabled = NO;
    self.luckyPickerView.dataSource = self;
    self.luckyPickerView.delegate = self;
    for (int i = 0; i < self.luckyPickerView.numberOfComponents; i++) {
        [self.luckyPickerView selectRow:16384 / 2 + 5 inComponent:i animated:NO];
    }
}

- (void)random
{
    NSLog(@"random %@", [NSThread currentThread]);
    while (!self.queue.isSuspended) {
        [NSThread sleepForTimeInterval:0.01];
        int num1 = arc4random_uniform(16384);
        int num2 = arc4random_uniform(16384);
        int num3 = arc4random_uniform(16384);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //            self.label1.text = [NSString stringWithFormat:@"%d", num1];
            //            self.label2.text = [NSString stringWithFormat:@"%d", num2];
            //            self.label3.text = [NSString stringWithFormat:@"%d", num3];
            [self.luckyPickerView selectRow:num1 inComponent:0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.luckyPickerView selectRow:num2 inComponent:1 animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.luckyPickerView selectRow:num3 inComponent:2 animated:YES];
                });
            });
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", row % 10];
}

@end
