//
//  WatchViewController.m
//  LDAWatch
//
//  Created by 李冬骜 on 15/10/13.
//  Copyright © 2015年 Dongao Li. All rights reserved.
//

#import "WatchViewController.h"

#define kViewSize self.view.frame.size
#define kPointerWidth 2

@interface WatchViewController ()

@property (nonatomic, weak) CALayer* mainWatch;
@property (nonatomic, weak) CALayer* mainSecond;
@property (nonatomic, weak) CALayer* mainMinute;
@property (nonatomic, weak) CALayer* mainHour;
@property (nonatomic, weak) CALayer* secondWatch;
@property (nonatomic, weak) CALayer* minuteWatch;
@property (nonatomic, weak) CALayer* countSecond;
@property (nonatomic, weak) CALayer* countMinute;

@property (nonatomic, weak) UILabel* brandLabel;
@property (nonatomic, weak) UILabel* dateLabel;
@property (nonatomic, weak) UILabel* weekDayLabel;

@property (nonatomic, strong) NSTimer* secondTimer;
@property (nonatomic, strong) NSTimer* minuteTimer;

@property (nonatomic, assign) BOOL startIsClick;

@end

@implementation WatchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate* dat = [NSDate date];

    NSInteger day = [cal component:NSCalendarUnitDay fromDate:dat];
    NSInteger month = [cal component:NSCalendarUnitMonth fromDate:dat];
    NSInteger year = [cal component:NSCalendarUnitYear fromDate:dat];
    NSInteger weekDay = [cal component:NSCalendarUnitWeekday fromDate:dat];

    NSArray* weekDayArray = @[
        @"Sunday",
        @"Monday",
        @"Tuesday",
        @"Wednesday",
        @"Thursday",
        @"Friday",
        @"Saturday"
    ];

    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    //  主表盘
    self.mainWatch = [self watchLayerWithBounds:CGRectMake(0, 0, 300, 300) andPosition:CGPointMake(kViewSize.width * 0.5, kViewSize.height * 0.4)];
    ;
    //  秒计时表盘
    self.secondWatch = [self watchLayerWithBounds:CGRectMake(0, 0, 60, 60) andPosition:CGPointMake(135, kViewSize.height * 0.4)];
    //  分计时表盘
    self.minuteWatch = [self watchLayerWithBounds:CGRectMake(0, 0, 60, 60) andPosition:CGPointMake(240, kViewSize.height * 0.4)];
    //  3个按钮
    [self addbutton:5 Title:@"开始计时" Color:[UIColor greenColor] andTag:0];
    [self addbutton:5 + self.view.frame.size.width / 3 Title:@"暂停计时" Color:[UIColor yellowColor] andTag:1];
    [self addbutton:5 + self.view.frame.size.width / 3 * 2 Title:@"停止计时" Color:[UIColor redColor] andTag:2];
    //  品牌名
    self.brandLabel = [self labelWithY:self.view.frame.size.height * 0.3 andText:@"PATEK PHILIPPE"];
    self.brandLabel.textColor = [UIColor colorWithRed:0.780 green:0.486 blue:0.282 alpha:1.000];
    //  日期
    self.dateLabel = [self labelWithY:self.view.frame.size.height * 0.44 andText:[NSString stringWithFormat:@"%ld / %ld / %ld", year, month, day]];
    //  星期
    self.weekDayLabel = [self labelWithY:CGRectGetMaxY(self.dateLabel.frame) - 5 andText:[NSString stringWithFormat:@"%@", weekDayArray[weekDay - 1]]];
    //  计时分针
    self.countMinute = [self pointerLayerWithBounds:CGRectMake(0, 0, kPointerWidth, 32) Position:_minuteWatch.position andBgdColor:[UIColor brownColor]];
    //  计时秒针
    self.countSecond = [self pointerLayerWithBounds:CGRectMake(0, 0, kPointerWidth, 32) Position:_secondWatch.position andBgdColor:[UIColor purpleColor]];
    //  主时针
    self.mainHour = [self pointerLayerWithBounds:CGRectMake(0, 0, kPointerWidth * 4, 140) Position:_mainWatch.position andBgdColor:[UIColor blackColor]];
    //  主分针
    self.mainMinute = [self pointerLayerWithBounds:CGRectMake(0, 0, kPointerWidth * 2, 160) Position:_mainWatch.position andBgdColor:[UIColor blackColor]];
    //  主秒针
    self.mainSecond = [self pointerLayerWithBounds:CGRectMake(0, 0, kPointerWidth, 160) Position:_mainWatch.position andBgdColor:[UIColor redColor]];

    [self timeChange];

    CADisplayLink* link =
        [CADisplayLink displayLinkWithTarget:self
                                    selector:@selector(timeChange)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (CALayer*)watchLayerWithBounds:(CGRect)bounds andPosition:(CGPoint)position
{
    CALayer* layer = [[CALayer alloc] init];
    layer.bounds = bounds;
    layer.position = position;
    layer.contents = (__bridge id)([UIImage imageNamed:@"clock"].CGImage);
    layer.cornerRadius = layer.bounds.size.width * 0.5;
    layer.masksToBounds = YES;
    [self.view.layer addSublayer:layer];
    return layer;
}

- (UILabel*)labelWithY:(CGFloat)y andText:(NSString*)text
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    return label;
}

- (CALayer*)pointerLayerWithBounds:(CGRect)bounds Position:(CGPoint)position andBgdColor:(UIColor*)bgdColor
{
    CALayer* layer = [[CALayer alloc] init];
    layer.bounds = bounds;
    layer.position = position;
    layer.backgroundColor = bgdColor.CGColor;
    layer.anchorPoint = CGPointMake(0.5, 0.8);
    [self.view.layer addSublayer:layer];
    return layer;
}

- (void)addbutton:(CGFloat)x Title:(NSString*)title Color:(UIColor*)color andTag:(NSInteger)tag
{
    UIButton* button = [[UIButton alloc] init];
    [button setFrame:CGRectMake(x, self.view.frame.size.height * 0.4 + 160,
                         self.view.frame.size.width / 3 - 10, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:color];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = tag;
    [self.view addSubview:button];
    [button addTarget:self
                  action:@selector(didClickBtn:)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)timeChange
{
    CGFloat angle = 2 * M_PI / 60;
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDate* dat = [NSDate date];
    CGFloat second = [cal component:NSCalendarUnitSecond fromDate:dat];
    CGFloat nanoSecond = [cal component:NSCalendarUnitNanosecond fromDate:dat];
    CGFloat minute = [cal component:NSCalendarUnitMinute fromDate:dat];
    CGFloat hour = [cal component:NSCalendarUnitHour fromDate:dat];

    second = second + nanoSecond * 0.000000001;

    self.mainSecond.transform = CATransform3DMakeRotation(second * angle, 0, 0, 1);
    self.mainMinute.transform = CATransform3DMakeRotation(minute * angle + second * angle / 60, 0, 0, 1);
    self.mainHour.transform = CATransform3DMakeRotation(hour * angle * 5 + minute * angle / 12, 0, 0, 1);
}

- (void)didClickBtn:(UIButton*)button
{
    if (button.tag == 0) {
        [self startTimer];
        self.startIsClick = YES;
    }
    else if (button.tag == 2) {
        [_secondTimer invalidate];
        [_minuteTimer invalidate];
        self.countSecond.transform = CATransform3DIdentity;
        self.countMinute.transform = CATransform3DIdentity;
        self.startIsClick = NO;
    }
    else {
        if (self.startIsClick) {
            button.selected = !button.selected;
            if (button.selected) {
                [_secondTimer invalidate];
                [_minuteTimer invalidate];
            }
            else {
                [self startTimer];
            }
        }
    }
}

- (void)secondChange
{
    self.countSecond.transform = CATransform3DRotate(self.countSecond.transform, 2 * M_PI / 600, 0, 0, 1);
}

- (void)minuteChange
{
    self.countMinute.transform = CATransform3DRotate(self.countMinute.transform, 2 * M_PI / 3600, 0, 0, 1);
}

- (void)startTimer
{
    _secondTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                    target:self
                                                  selector:@selector(secondChange)
                                                  userInfo:nil
                                                   repeats:YES];
    _minuteTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(minuteChange)
                                                  userInfo:nil
                                                   repeats:YES];
}

@end
