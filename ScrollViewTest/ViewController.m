//
//  ViewController.m
//  ScrollViewTest
//
//  Created by 李冬骜 on 5/11/16.
//  Copyright © 2016 Dongao Li. All rights reserved.
//

#import "ViewController.h"
#import "hitTestViewController.h"
#import "LDAFishController.h"
#import "transitionViewController.h"
#import "ScrollViewTest-Swift.h"
#import "DynamicViewController.h"
#import "ChannelController.h"
#import "WatchViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSArray *demoTitles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Demos";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.demoTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.text = self.demoTitles[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIStoryboard *hitTestBoard = [UIStoryboard storyboardWithName:@"hitTest" bundle:nil];
        hitTestViewController *hitTestVC = [hitTestBoard instantiateInitialViewController];
        [self.navigationController pushViewController:hitTestVC animated:YES];
    } else if (indexPath.row == 1) {
        LDATabBarViewController *tabbarVC = [[LDATabBarViewController alloc] init];
        [self.navigationController pushViewController:tabbarVC animated:YES];
    } else if (indexPath.row == 2) {
        LDAFishController *fishVC = [[LDAFishController alloc] init];
        [self.navigationController pushViewController:fishVC animated:YES];
    } else if (indexPath.row == 3) {
        UIStoryboard *transitionBoard = [UIStoryboard storyboardWithName:@"transition" bundle:nil];
        transitionViewController *transitionVC = [transitionBoard instantiateInitialViewController];
        [self.navigationController pushViewController:transitionVC animated:YES];
    } else if (indexPath.row == 4) {
        UIStoryboard *dynamicBoard = [UIStoryboard storyboardWithName:@"Dynamic" bundle:nil];
        transitionViewController *dynamicVC = [dynamicBoard instantiateInitialViewController];
        [self.navigationController pushViewController:dynamicVC animated:YES];
    } else if (indexPath.row == 5) {
        WatchViewController *watchVC = [[WatchViewController alloc] init];
        [self.navigationController pushViewController:watchVC animated:YES];
    } else if (indexPath.row == 6) {
        UIStoryboard *channelBoard = [UIStoryboard storyboardWithName:@"Channel" bundle:nil];
        transitionViewController *channelVC = [channelBoard instantiateInitialViewController];
        [self.navigationController pushViewController:channelVC animated:YES];
    } else if (indexPath.row == 7) {
        UIStoryboard *tigerBoard = [UIStoryboard storyboardWithName:@"Tiger" bundle:nil];
        transitionViewController *tigerVC = [tigerBoard instantiateInitialViewController];
        [self.navigationController pushViewController:tigerVC animated:YES];
    }
}

- (NSArray *)demoTitles
{
    return @[
             @"hitTest", // Demo 1
             @"不规则按钮点击", // Demo 2
             @"基本动画, 关键帧动画, 组动画", // Demo 3
             @"转场动画", // Demo 4
             @"UIDynamic", // Demo 5
             @"CADisplayLink", // Demo 6
             @"手势和UIView动画", // Demo 7
             @"UIPickerView" // Demo 8
             ];
}

@end
