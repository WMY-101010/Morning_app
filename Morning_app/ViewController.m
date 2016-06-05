//
//  ViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "ViewController.h"
#import "CircleSlider.h"
#import "notificationManager.h"
#import "dateManager.h"
#import "GetWeatherData.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet CircleSlider *minuteSlider;
@property (weak, nonatomic) IBOutlet CircleSlider *hourSlider;
@property (weak, nonatomic) IBOutlet UIButton *addClockButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//checkView
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkViewbuttomCons;
//
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *settingViewCons;

//repeatView
@property (weak, nonatomic) IBOutlet UIView *repeatView;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;
@property (weak, nonatomic) IBOutlet UIButton *monButton;
@property (weak, nonatomic) IBOutlet UIButton *tueButton;
@property (weak, nonatomic) IBOutlet UIButton *wedButton;
@property (weak, nonatomic) IBOutlet UIButton *thuButton;
@property (weak, nonatomic) IBOutlet UIButton *friButton;
@property (weak, nonatomic) IBOutlet UIButton *satButton;

//delayView
@property (weak, nonatomic) IBOutlet UIView *delayView;
@property (weak, nonatomic) IBOutlet UIButton *showSliderButton;

@property (weak, nonatomic) IBOutlet UILabel *showDelayTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *changeDelayTimeSlider;
@property (weak, nonatomic) IBOutlet UIView *sliderView;

//MusicView
@property (weak, nonatomic) IBOutlet UIView *MusicView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MusicViewTopCons;

//barItem
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarItem;

@property (copy, nonatomic) NSMutableArray *editArray;
@property (assign, nonatomic) NSInteger row;

//clocktableView
@property (weak, nonatomic) IBOutlet UITableView *showClockTable;

@property (nonatomic) NSMutableArray *t_array;
@property (nonatomic) int arrayFirstValue;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clockTableBottom;


//------promptView
#pragma mark promptView
@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet UILabel *flabel;
@property (weak, nonatomic) IBOutlet UILabel *slabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;



@end


static int setHour;
static int setMinute;


static int sunMark = 1;  // 1表示button没有被点击
static int monMark = 1;
static int tueMark = 1;
static int wedMark = 1;
static int thuMark = 1;
static int friMark = 1;
static int satMark = 1;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view, typically from a nib.
    _minuteSlider.kindOfSlider = true; //minuteSlider只能转动360度
    //navigatioN设置
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.title = @"设置";
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.title = @"Morning";

    _sunButton.tintColor = [UIColor grayColor];
    _monButton.tintColor = [UIColor grayColor];
    _tueButton.tintColor = [UIColor grayColor];
    _wedButton.tintColor = [UIColor grayColor];
    _thuButton.tintColor = [UIColor grayColor];
    _friButton.tintColor = [UIColor grayColor];
    _satButton.tintColor = [UIColor grayColor];

    _settingView.alpha = 0;
    //判断promptview是否出现
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    if (narry == nil) {
        _promptView.alpha = 1;
        _image.alpha = 1;
        _flabel.alpha = 0.3;
        _slabel.alpha = 0.3;
    }
    else
    {
        _promptView.alpha = 0;
        _promptView.alpha = 0;
        _image.alpha = 0;
        _flabel.alpha = 0;
        _slabel.alpha = 0;
    }
    
    //timeLabel设置
    [self.minuteSlider addTarget:self action:@selector(minuteValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.hourSlider addTarget:self action:@selector(hourValueChange:) forControlEvents:UIControlEventValueChanged];
    
    _showClockTable.delegate = self;
    _showClockTable.dataSource = self;
    
    // table 设置
    _clockTableBottom.constant = 0;
    _showClockTable.delegate = self;
    _showClockTable.dataSource = self;
    _showClockTable.rowHeight = 80;
    _showClockTable.backgroundColor = [UIColor clearColor];

    //过去天气信息

    GetWeatherData *weatherData = [[GetWeatherData alloc] init];
    BOOL result = [weatherData getDataFromServer];
    if (result == false) {
        //没有返回结果，提示用户没有接入网络，更新UI
    }


}



-(void)hourValueChange:(CircleSlider *) slider
{
    //
    int newVal = ((int)(_hourSlider.angle) / 30) < 1 ? 12 : (int)(_hourSlider.angle / 30);
    setHour = newVal;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%@", newVal, [oldTime substringFromIndex:colonRange.location + 1]];
}

-(void) minuteValueChange:(CircleSlider *) slider
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger minute = [dateComponent minute];
    
    int newVal = (int)(_minuteSlider.angle  - 359) ? (int)(_minuteSlider.angle / 6) : 0;
    setMinute = (int)minute;
    setMinute = newVal;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%@:%02d", [oldTime substringToIndex:colonRange.location], newVal];
}



//点击加号，进入闹钟编辑模式
- (IBAction)addClock:(UIButton *)sender {
    //
    self.navigationItem.title = @"New";
    // self.navigationItem.leftBarButtonItem.
    self.navigationItem.leftBarButtonItem.enabled = true;
    self.navigationItem.leftBarButtonItem.title = @"取消";
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.title = @"";
    
    //circleSlider动画
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _hourSlider.alpha = 0.5;
        _minuteSlider.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _minuteSlider.alpha = 0.5;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1, 1);
        _hourSlider.alpha = 1;
        _hourSlider.clircleAlpha = 1;
        _minuteSlider.transform = CGAffineTransformMakeScale(1, 1);
        _minuteSlider.alpha = 1;
        _minuteSlider.clircleAlpha = 1;
    } completion:nil];
    //----------------------
    //checkView出现
    [UIView animateWithDuration:0.2 delay:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //改变checkView的约束
        _checkViewbuttomCons.constant = 0;
        [self.checkView layoutIfNeeded];
    } completion:nil];
    
    //点击add，add图标消失
    [UIView animateWithDuration:0.5 delay:0.0  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.alpha = 0;
        _timeLabel.transform =CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished){
        //获取并显示当前时间,slider滑动到当前时间
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = kCFCalendarUnitHour | kCFCalendarUnitMinute;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        NSInteger hour = [dateComponent hour];
        NSInteger minute = [dateComponent minute];
        setHour = (int)hour;
        setMinute = (int)minute;
        [_hourSlider move:(hour) * 30];
        [_minuteSlider move:minute * 6];
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)hour, (int)minute];
        
    }];
    
    [UILabel animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.alpha = 1;
        _checkView.alpha = 1;
        
    } completion:nil];
    [UIView animateWithDuration:2 delay:0.0  options:UIViewAnimationOptionCurveEaseOut animations:^{
        _addClockButton.transform = CGAffineTransformMakeRotation(M_PI);
        _addClockButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    //timeLabel出现
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.transform =CGAffineTransformMakeScale(1, 1);
    } completion:nil];

    //settingView 出现
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _settingView.alpha =1;
        _settingViewCons.constant = 8;
        [self.settingView layoutIfNeeded];
    } completion:nil];
    
    //clocktable 消失
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _clockTableBottom.constant = -240;
        [self.showClockTable layoutIfNeeded];
    } completion:nil];
}

//点击勾，确认添加一个闹钟
- (IBAction)check:(UIButton *)sender {
    [_minuteSlider letHandleGo: 0.0];
    [_hourSlider letHandleGo: 0.0];
    //circleslider背景出现
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _hourSlider.alpha = 0.5;
        _minuteSlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _minuteSlider.alpha = 0.5;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1, 1);
        _hourSlider.alpha = 1;
        _minuteSlider.transform = CGAffineTransformMakeScale(1, 1);
        _minuteSlider.alpha = 1;
    } completion:nil];
    
    //add出现
    [UIButton animateWithDuration:0.3 delay:0.3  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.transform = CGAffineTransformMakeRotation( M_PI);
        _addClockButton.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    //timeLabel消失
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.transform =CGAffineTransformMakeScale(0.01, 0.01);
        _timeLabel.alpha = 0;
    } completion:nil];
    
    //cheView消失
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //改变checkView的约束
        _checkViewbuttomCons.constant = -44;
        [self.checkView layoutIfNeeded];
    } completion:nil];
    
    //settingView 消失
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _settingView.alpha = 0;
        _settingViewCons.constant = 500;
        [self.settingView layoutIfNeeded];
    } completion:^(BOOL finished){
        //settingView回到初始状态
        _MusicViewTopCons.constant = -1;
        _changeDelayTimeSlider.alpha = 0;
        _changeDelayTimeSlider.value = 15;
        _showDelayTimeLabel.text = @"15";
        
    }];
    //设置闹钟
    notificationManager *manager = [[notificationManager alloc] init];
    int delaytime = _changeDelayTimeSlider.value;
    if ([self.navigationItem.title isEqualToString:@"New"]) {
        [manager addLocalNotificationWithHour:setHour Minute:setMinute Sun:sunMark Mon:monMark Tue:tueMark Wed:wedMark Thu:thuMark Fri:friMark Sat:satMark Delay:delaytime];
    }
    if ([self.navigationItem.title isEqualToString:@"编辑"]) {
        //修改完之后，需要先在plist中找到之前的数据在替换
        //删除之前的闹钟
        NSString * notificationMark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_editArray[0], _editArray[1],_editArray[2],_editArray[3],_editArray[4],_editArray[5],_editArray[6],_editArray[7],_editArray[8],_editArray[9]];
        
        [self deleteNotificationWithUserInfo:notificationMark];
        //添加新的闹钟
        //设置闹钟
        notificationManager *manager = [[notificationManager alloc] init];
        int delaytime = _changeDelayTimeSlider.value;
        NSArray *array = [manager addButNoSaveInPlistLocalNotificationWithHour:setHour Minute:setMinute Sun:sunMark Mon:monMark Tue:tueMark Wed:wedMark Thu:thuMark Fri:friMark Sat:satMark Delay:delaytime];
        
        //在plist中找到之间的值替换
        dateManager * mangerToChangeValue = [dateManager sharedManager];
        [mangerToChangeValue changeDataWithData:array atRow:_row];
    }
    
    //刷新UITableView
    [_showClockTable reloadData];
    //clocktable 出现
    NSLog(@"check");
    if ([self.navigationItem.title isEqualToString:@"New"]) {
        [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _clockTableBottom.constant = 0;
            [self.showClockTable layoutIfNeeded];
        } completion:^(BOOL finished){
            [_showClockTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_t_array.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _clockTableBottom.constant = 0;
            [self.showClockTable layoutIfNeeded];
        } completion:nil];
    }
    
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.title = @"设置";
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.title = @"Morning";
    //让repeatView回到之前的状态，检查buttonMark
    if (sunMark == 0) {
        //
        [self sunButtonCheck:_repeatView];
    }
    if (monMark == 0) {
        //
        [self monButtonCheck:_repeatView];
    }
    if (tueMark == 0) {
        //
        [self tueButtonCheck:_repeatView];
    }
    if (wedMark == 0) {
        //
        [self wedButtonCheck:_repeatView];
    }
    if (thuMark == 0) {
        //
        [self thuButtonCheck:_repeatView];
    }
    if (friMark == 0) {
        //
        [self friButtonCheck:_repeatView];
    }
    if (satMark == 0) {
        //
        [self satButtonCheck:_repeatView];
    }
}

//点击左上角取消推出编辑模式
- (IBAction)cancelEdit:(UIBarButtonItem *)sender {
    //
    [_minuteSlider letHandleGo: 0.0];
    [_hourSlider letHandleGo: 0.0];
    //circleslider背景出现
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _hourSlider.alpha = 0.5;
        _minuteSlider.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _minuteSlider.alpha = 0.5;
    } completion:nil];
    [UIView animateWithDuration:0.3 delay:0.2 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1, 1);
        _hourSlider.alpha = 1;
        _minuteSlider.transform = CGAffineTransformMakeScale(1, 1);
        _minuteSlider.alpha = 1;
    } completion:nil];
    
    //add出现
    [UIButton animateWithDuration:0.3 delay:0.3  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.transform = CGAffineTransformMakeRotation( M_PI);
        _addClockButton.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    //timeLabel消失
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.transform =CGAffineTransformMakeScale(0.01, 0.01);
        _timeLabel.alpha = 0;
    } completion:nil];
    
    //cheView消失
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //改变checkView的约束
        _checkViewbuttomCons.constant = -44;
        [self.checkView layoutIfNeeded];
    } completion:nil];
    //让repeatView回到之前的状态，检查buttonMark
    if (sunMark == 0) {
        //
        [self sunButtonCheck:_repeatView];
    }
    if (monMark == 0) {
        //
        [self monButtonCheck:_repeatView];
    }
    if (tueMark == 0) {
        //
        [self tueButtonCheck:_repeatView];
    }
    if (wedMark == 0) {
        //
        [self wedButtonCheck:_repeatView];
    }
    if (thuMark == 0) {
        //
        [self thuButtonCheck:_repeatView];
    }
    if (friMark == 0) {
        //
        [self friButtonCheck:_repeatView];
    }
    if (satMark == 0) {
        //
        [self satButtonCheck:_repeatView];
    }
    
    //settingView 消失
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _settingView.alpha = 0;
        _settingViewCons.constant = 500;
        [self.settingView layoutIfNeeded];
    } completion:^(BOOL finished){
        //settingView回到初始状态
        _MusicViewTopCons.constant = -1;
        _changeDelayTimeSlider.alpha = 0;
        _changeDelayTimeSlider.value = 15;
        _showDelayTimeLabel.text = @"15";
        
    }];
    //clocktable 出现
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _clockTableBottom.constant = 0;
        [self.showClockTable layoutIfNeeded];
    } completion:^(BOOL finished){

    }];
    
    //navigationbar改变
    //
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.title = @"设置";
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.title = @"Morning";

}

#pragma mark repeatView中的button点击
//-----repeatButton_function
- (IBAction)sunButtonCheck:(id)sender
{
    if (sunMark == 1)
    {
        if (monMark == 1)
        {
            _sunButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _sunButton.tintColor = [UIColor whiteColor];
            sunMark = 0;
            //圆形button
            [self allCircle:_sunButton];
        }
        else
        {
            if (tueMark == 1)
            {
                _sunButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _sunButton.tintColor = [UIColor whiteColor];

                sunMark = 0;
                //圆形button
                [self letCircle:_sunButton];
                [self rightCircle:_monButton];
            }
            else
            {
                _sunButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _sunButton.tintColor = [UIColor whiteColor];

                sunMark = 0;
                [self letCircle:_sunButton];
                [self allRect:_monButton];
            }
        }
    }
    else
    {
        if (tueMark == 0) {
            _sunButton.backgroundColor = [UIColor clearColor];
            _sunButton.tintColor = [UIColor grayColor];

            sunMark = 1;
            [self letCircle:_monButton];
        }
        else
        {
            _sunButton.backgroundColor = [UIColor clearColor];
            _sunButton.tintColor = [UIColor grayColor];

            sunMark = 1;
            [self allCircle:_monButton];
        }
    }
}

- (IBAction)monButtonCheck:(id)sender
{
    if (monMark == 1) {
        if (sunMark == 1 && tueMark == 1) {
            _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _monButton.tintColor = [UIColor whiteColor];

            [self allCircle:_monButton];
            monMark = 0;
        }
        if (sunMark == 0 && tueMark == 1) {
            _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _monButton.tintColor = [UIColor whiteColor];

            [self rightCircle:_monButton];
            [self letCircle:_sunButton];
            monMark = 0;
        }
        if (sunMark == 0 && tueMark == 0)
        {
            if (wedMark == 1)
            {
                _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _monButton.tintColor = [UIColor whiteColor];

                [self allRect:_monButton];
                [self letCircle:_sunButton];
                [self rightCircle:_tueButton];
                monMark = 0;
            }
            else
            {
                _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _monButton.tintColor = [UIColor whiteColor];

                [self allRect:_monButton];
                [self letCircle:_sunButton];
                [self allRect:_tueButton];
                monMark = 0;
            }
        }
        if (sunMark == 1  && tueMark == 0)
        {
            if (wedMark == 1)
            {
                _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _monButton.tintColor = [UIColor whiteColor];

                [self letCircle:_monButton];
                [self rightCircle:_tueButton];
                monMark = 0;
            }
            else
            {
                _monButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _monButton.tintColor = [UIColor whiteColor];

                [self letCircle:_monButton];
                [self allRect:_tueButton];
                monMark = 0;
            }
        }
        
    }
    else
    {
        if (sunMark == 1 && tueMark == 1) {
            _monButton.backgroundColor = [UIColor clearColor];
            _monButton.tintColor = [UIColor grayColor];

            monMark = 1;
        }
        if (sunMark == 0 && tueMark == 1) {
            _monButton.backgroundColor = [UIColor clearColor];
            _monButton.tintColor = [UIColor grayColor];

            monMark = 1;
            [self allCircle:_sunButton];
        }
        if (sunMark == 0 && tueMark == 0)
        {
            if (wedMark == 1)
            {
                _monButton.backgroundColor = [UIColor clearColor];
                _monButton.tintColor = [UIColor grayColor];

                monMark = 1;
                [self allCircle:_sunButton];
                [self allCircle:_tueButton];
            }
            else
            {
                _monButton.backgroundColor = [UIColor clearColor];
                _monButton.tintColor = [UIColor grayColor];

                monMark = 1;
                [self allCircle:_sunButton];
                [self letCircle:_tueButton];
            }
        }
        if (sunMark == 1 && tueMark == 0)
        {
            if (wedMark == 1)
            {
                _monButton.backgroundColor = [UIColor clearColor];
                _monButton.tintColor = [UIColor grayColor];

                monMark = 1;
                [self allCircle:_tueButton];
            }
            else
            {
                _monButton.backgroundColor = [UIColor clearColor];
                _monButton.tintColor = [UIColor grayColor];

                monMark = 1;
                [self letCircle:_tueButton];
            }
        }
    }
}

- (IBAction)tueButtonCheck:(id)sender
{
    if (tueMark == 1) {
        if (monMark == 1 && wedMark == 1) {
            _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _tueButton.tintColor = [UIColor whiteColor];

            tueMark = 0;
            [self allCircle:_tueButton];
        }
        if (monMark == 0 && wedMark == 1) {
            if (sunMark == 1) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self rightCircle:_tueButton];
                [self letCircle:_monButton];
            }
            else
            {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self rightCircle:_tueButton];
                [self allRect:_monButton];
            }
            
        }
        
        if (monMark == 0 && wedMark == 0) {
            if (sunMark == 1 && thuMark == 1) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self allRect:_tueButton];
                [self letCircle:_monButton];
                [self rightCircle:_wedButton];
            }
            if (sunMark == 0 && thuMark == 1) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self allRect:_tueButton];
                [self allRect:_monButton];
                [self rightCircle:_wedButton];
            }
            if (sunMark == 1 && thuMark == 0) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self allRect:_tueButton];
                [self letCircle:_monButton];
                [self allRect:_wedButton];
            }
            if (sunMark == 0 && thuMark == 0) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self allRect:_tueButton];
                [self allRect:_monButton];
                [self allRect:_wedButton];
            }
            
            
        }
        if (monMark == 1 && wedMark == 0) {
            if (thuMark == 1) {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self letCircle:_tueButton];
                [self rightCircle:_wedButton];
            }
            else
            {
                _tueButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _tueButton.tintColor = [UIColor whiteColor];

                tueMark = 0;
                [self letCircle:_tueButton];
                [self allRect:_wedButton];
            }
        }
    }
    else
    {
        if (monMark == 1 && wedMark == 1) {
            _tueButton.backgroundColor = [UIColor clearColor];
            _tueButton.tintColor = [UIColor grayColor];

            tueMark = 1;
        }
        if (monMark == 0 && wedMark == 1) {
            if (sunMark == 1) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self allCircle:_monButton];
            }
            else
            {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self rightCircle:_monButton];
            }
            
        }
        
        if (monMark == 0 && wedMark == 0) {
            if (sunMark == 1 && thuMark == 1) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self allCircle:_monButton];
                [self allCircle:_wedButton];
            }
            if (sunMark == 0 && thuMark == 1) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self rightCircle:_monButton];
                [self allCircle:_wedButton];
            }
            if (sunMark == 1 && thuMark == 0) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self allCircle:_monButton];
                [self letCircle:_wedButton];
            }
            if (sunMark == 0 && thuMark == 0) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self rightCircle:_monButton];
                [self letCircle:_wedButton];
            }
            
            
        }
        if (monMark == 1 && wedMark == 0) {
            if (thuMark == 1) {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self allCircle:_wedButton];
            }
            else
            {
                _tueButton.backgroundColor = [UIColor clearColor];
                _tueButton.tintColor = [UIColor grayColor];

                tueMark = 1;
                [self letCircle:_wedButton];
            }
        }
    }
}

- (IBAction)wedButtonCheck:(id)sender
{
    if (wedMark == 1) {
        if (tueMark == 1 && thuMark == 1) {
            _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _wedButton.tintColor = [UIColor whiteColor];

            wedMark = 0;
            [self allCircle:_wedButton];
        }
        if (tueMark == 0 && thuMark == 1) {
            if (monMark == 1) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self rightCircle:_wedButton];
                [self letCircle:_tueButton];
            }
            else
            {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self rightCircle:_wedButton];
                [self allRect:_tueButton];
            }
            
        }
        
        if (tueMark == 0 && thuMark == 0) {
            if (monMark == 1 && friMark == 1) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self allRect:_wedButton];
                [self letCircle:_tueButton];
                [self rightCircle:_thuButton];
            }
            if (monMark == 0 && friMark == 1) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self allRect:_wedButton];
                [self allRect:_tueButton];
                [self rightCircle:_thuButton];
            }
            if (monMark == 1 && friMark == 0) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self allRect:_wedButton];
                [self letCircle:_tueButton];
                [self allRect:_thuButton];
            }
            if (monMark == 0 && friMark == 0) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self allRect:_wedButton];
                [self allRect:_tueButton];
                [self allRect:_thuButton];
            }
            
            
        }
        if (tueMark == 1 && thuMark == 0) {
            if (friMark == 1) {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self letCircle:_wedButton];
                [self rightCircle:_thuButton];
            }
            else
            {
                _wedButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _wedButton.tintColor = [UIColor whiteColor];

                wedMark = 0;
                [self letCircle:_wedButton];
                [self allRect:_thuButton];
            }
        }
    }
    else
    {
        if (tueMark == 1 && thuMark == 1) {
            _wedButton.backgroundColor = [UIColor clearColor];
            _wedButton.tintColor = [UIColor grayColor];

            wedMark = 1;
        }
        if (tueMark == 0 && thuMark == 1) {
            if (monMark == 1) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self allCircle:_tueButton];
            }
            else
            {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self rightCircle:_tueButton];
            }
            
        }
        
        if (tueMark == 0 && thuMark == 0) {
            if (monMark == 1 && friMark == 1) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self allCircle:_tueButton];
                [self allCircle:_thuButton];
            }
            if (monMark == 1 && friMark == 0) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self allCircle:_tueButton];
                [self letCircle:_thuButton];
            }
            if (monMark == 0 && friMark == 0) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self rightCircle:_tueButton];
                [self letCircle:_thuButton];
            }
            if (monMark == 0 && friMark == 1) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self rightCircle:_tueButton];
                [self allCircle:_thuButton];
            }

            
            
        }
        if (tueMark == 1 && thuMark == 0) {
            if (friMark == 1) {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self allCircle:_thuButton];
            }
            else
            {
                _wedButton.backgroundColor = [UIColor clearColor];
                _wedButton.tintColor = [UIColor grayColor];

                wedMark = 1;
                [self letCircle:_thuButton];
            }
        }
    }
}

- (IBAction)thuButtonCheck:(id)sender
{
    if (thuMark == 1) {
        if (wedMark == 1 && friMark == 1) {
            _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _thuButton.tintColor = [UIColor whiteColor];

            thuMark = 0;
            [self allCircle:_thuButton];
        }
        if (wedMark == 0 && friMark == 1) {
            if (tueMark == 1) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self rightCircle:_thuButton];
                [self letCircle:_wedButton];
            }
            else
            {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self rightCircle:_thuButton];
                [self allRect:_wedButton];
            }
            
        }
        
        if (wedMark == 0 && friMark == 0) {
            if (tueMark == 1 && satMark == 1) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self allRect:_thuButton];
                [self letCircle:_wedButton];
                [self rightCircle:_friButton];
            }
            if (tueMark == 0 && satMark == 1) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self allRect:_thuButton];
                [self allRect:_wedButton];
                [self rightCircle:_friButton];
            }
            if (tueMark == 1 && satMark == 0) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self allRect:_thuButton];
                [self letCircle:_wedButton];
                [self allRect:_friButton];
            }
            if (tueMark == 0 && satMark == 0) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self allRect:_thuButton];
                [self allRect:_wedButton];
                [self allRect:_friButton];
            }
            
            
        }
        if (wedMark == 1 && friMark == 0) {
            if (satMark == 1) {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self letCircle:_thuButton];
                [self rightCircle:_friButton];
            }
            else
            {
                _thuButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _thuButton.tintColor = [UIColor whiteColor];

                thuMark = 0;
                [self letCircle:_thuButton];
                [self allRect:_friButton];
            }
        }
    }
    else
    {
        if (wedMark == 1 && friMark == 1) {
            _thuButton.backgroundColor = [UIColor clearColor];
            _thuButton.tintColor = [UIColor grayColor];

            thuMark = 1;
            
        }
        if (wedMark == 0 && friMark == 1) {
            if (tueMark == 1) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self allCircle:_wedButton];
            }
            else
            {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self rightCircle:_wedButton];
            }
            
        }
        
        if (wedMark == 0 && friMark == 0) {
            if (tueMark == 1 && satMark == 1) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self allCircle:_wedButton];
                [self allCircle:_friButton];
            }
            if (tueMark == 0 && satMark == 1) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self rightCircle:_wedButton];
                [self allCircle:_friButton];
            }
            if (tueMark == 1 && satMark == 0) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self allCircle:_wedButton];
                [self letCircle:_friButton];
            }
            if (tueMark == 0 && satMark == 0) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self rightCircle:_wedButton];
                [self letCircle:_friButton];
            }
            
            
        }
        if (wedMark == 1 && friMark == 0) {
            if (satMark == 1) {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self allCircle:_friButton];
            }
            else
            {
                _thuButton.backgroundColor = [UIColor clearColor];
                _thuButton.tintColor = [UIColor grayColor];

                thuMark = 1;
                [self letCircle:_friButton];
            }
        }
    }
}
- (IBAction)friButtonCheck:(id)sender
{
    if (friMark == 1)
    {
        if (thuMark == 1 && satMark == 1) {
            _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _friButton.tintColor = [UIColor whiteColor];

            friMark = 0;
            [self allCircle:_friButton];
        }
        if (thuMark == 0 && satMark == 1) {
            if (wedMark == 1) {
                _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _friButton.tintColor = [UIColor whiteColor];

                friMark = 0;
                [self letCircle:_thuButton];
                [self rightCircle:_friButton];
            }
            else
            {
                _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _friButton.tintColor = [UIColor whiteColor];

                friMark = 0;
                [self allRect:_thuButton];
                [self rightCircle:_friButton];
            }
        }
        if (thuMark == 0 && satMark == 0)
        {
            if (wedMark == 1) {
                _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _friButton.tintColor = [UIColor whiteColor];

                friMark = 0;
                [self letCircle:_thuButton];
                [self allRect:_friButton];
                [self rightCircle:_satButton];
            }
            else
            {
                _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _friButton.tintColor = [UIColor whiteColor];

                friMark = 0;
                [self allRect:_thuButton];
                [self allRect:_friButton];
                [self rightCircle:_satButton];
            }
        }
        if (thuMark == 1 && satMark == 0) {
            _friButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _friButton.tintColor = [UIColor whiteColor];

            friMark = 0;
            [self letCircle:_friButton];
            [self rightCircle:_satButton];
        }
    }
    else
    {
        if (thuMark == 1 && satMark == 1) {
            _friButton.backgroundColor = [UIColor clearColor];
            _friButton.tintColor = [UIColor grayColor];

            friMark = 1;
        }
        if (thuMark == 0 && satMark == 1) {
            if (wedMark == 1) {
                _friButton.backgroundColor = [UIColor clearColor];
                _friButton.tintColor = [UIColor grayColor];

                friMark = 1;
                [self allCircle:_thuButton];
            }
            else
            {
                _friButton.backgroundColor = [UIColor clearColor];
                _friButton.tintColor = [UIColor grayColor];

                friMark = 1;
                [self rightCircle:_thuButton];
            }
        }
        if (thuMark == 0 && satMark == 0)
        {
            if (wedMark == 1) {
                _friButton.backgroundColor = [UIColor clearColor];
                _friButton.tintColor = [UIColor grayColor];

                friMark = 1;
                [self allCircle:_thuButton];
                [self allCircle:_satButton];
            }
            else
            {
                _friButton.backgroundColor = [UIColor clearColor];
                _friButton.tintColor = [UIColor grayColor];

                friMark = 1;
                [self rightCircle:_thuButton];
                [self allCircle:_satButton];
            }
        }
        if (thuMark == 1 && satMark == 0) {
            _friButton.backgroundColor = [UIColor clearColor];
            _friButton.tintColor = [UIColor grayColor];

            friMark = 1;
            [self allCircle:_satButton];
        }
    }
}

- (IBAction)satButtonCheck:(id)sender
{
    if (satMark == 1) {
        if (friMark == 1)
        {
            _satButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
            _satButton.tintColor = [UIColor whiteColor];

            satMark = 0;
            [self allCircle:_satButton];
        }
        if (friMark == 0)
        {
            if (thuMark == 1)
            {
                _satButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _satButton.tintColor = [UIColor whiteColor];

                satMark = 0;
                [self letCircle:_friButton];
                [self rightCircle:_satButton];
            }
            else
            {
                _satButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:219/255.0 blue:74/255.0 alpha:1.0];
                _satButton.tintColor = [UIColor whiteColor];

                satMark = 0;
                [self allRect:_friButton];
                [self rightCircle:_satButton];
            }
        }
    }
    else
    {
        if (friMark == 1)
        {
            _satButton.backgroundColor = [UIColor clearColor];
            _satButton.tintColor = [UIColor grayColor];

            satMark = 1;
        }
        if (friMark == 0)
        {
            if (thuMark == 1)
            {
                _satButton.backgroundColor = [UIColor clearColor];
                _satButton.tintColor = [UIColor grayColor];

                satMark = 1;
                [self allCircle:_friButton];
            }
            else
            {
                _satButton.backgroundColor = [UIColor clearColor];
                _satButton.tintColor = [UIColor grayColor];

                satMark = 1;
                [self rightCircle:_friButton];
            }
        }
    }
}


//UITableDataSourceDelegate_function
#pragma mark UITableDataSourceDelegate函数实现
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    _t_array = [dataDictionary objectForKey:@"date"];
    //    NSLog(@"_t_array =%@",_t_array);
    if (_t_array.count == 0) {
        [UIView animateWithDuration:0.3 animations:^{
            _promptView.alpha = 1;
            _image.alpha = 1;
            _flabel.alpha = 0.3;
            _slabel.alpha = 0.3;
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.1 animations:^{
            _promptView.alpha = 0;
            _promptView.alpha = 0;
            _image.alpha = 0;
            _flabel.alpha = 0;
            _slabel.alpha = 0;
        }];
        
    }
    if ((int)_t_array.count < 4) {
        //
        _tableHight.constant = 80 * (int)_t_array.count;
    }
    else
    {
        _tableHight.constant = 240;
    }
    //    NSLog(@"_t_array.count = %lu",(unsigned long)_t_array.count);
    return _t_array.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell的重用标志
    static NSString *cellIdentification = @"cell";
    //从重用队列中取出cell
    UITableViewCell *cell = [_showClockTable dequeueReusableCellWithIdentifier:cellIdentification];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentification];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 20, 20)];
        imageView.image = [UIImage imageNamed:@"btn_on"];
        
        [cell.contentView addSubview:imageView];
    }
    
    //int hour = [_t_array[indexPath.row][0] intValue];
    int hour = [[[_t_array objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    int minute =  [[[_t_array objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
    
    NSString *str = [NSString stringWithFormat:@"%02d : %02d",hour,minute];
    
    cell.textLabel.textColor =  [UIColor colorWithRed:104/255 green:85/255 blue:64/255 alpha:0.8];
    cell.textLabel.text = [NSString stringWithString:str];
    

    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:30];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // NSArray *arr = [_t_array objectAtIndex:indexPath.row];
    _editArray = [_t_array objectAtIndex:indexPath.row];
    NSLog(@"_editArray = %@",_editArray);
    _row = indexPath.row;
    //arr数组中包涵着这个cell中的所有数据
    int hour = [_editArray[0] intValue];
    setHour = hour;
    
    int minute = [_editArray[1] intValue];
    setMinute = minute;
    int delay = [_editArray[2] intValue];
    
    int sun = [_editArray[3] intValue];
    int mon = [_editArray[4] intValue];
    int tue = [_editArray[5] intValue];
    int wed = [_editArray[6] intValue];
    int thu = [_editArray[7] intValue];
    int fri = [_editArray[8] intValue];
    int sat = [_editArray[9] intValue];
    //让repeatView回到之前的状态，检查buttonMark
    if (sun == 0) {
        //
        [self sunButtonCheck:_repeatView];
    }
    if (mon == 0) {
        //
        [self monButtonCheck:_repeatView];
    }
    if (tue == 0) {
        //
        [self tueButtonCheck:_repeatView];
    }
    if (wed == 0) {
        //
        [self wedButtonCheck:_repeatView];
    }
    if (thu == 0) {
        //
        [self thuButtonCheck:_repeatView];
    }
    if (fri == 0) {
        //
        [self friButtonCheck:_repeatView];
    }
    if (sat == 0) {
        //
        [self satButtonCheck:_repeatView];
    }
    
    //修改的view还是当前的view，hourslider和minuteslider显示时间，repeatview显示之前的重复日期，delaytime显示之前的时间
    _showDelayTimeLabel.text = [NSString stringWithFormat:@"%d",delay];
    _changeDelayTimeSlider.value = delay;
    //repeatView显示

    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _hourSlider.alpha = 0.5;
        _minuteSlider.transform = CGAffineTransformMakeScale(1.2, 1.2);
        _minuteSlider.alpha = 0.5;
    } completion:nil];
    [UIView animateWithDuration:0.4 delay:0.4 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _hourSlider.transform = CGAffineTransformMakeScale(1, 1);
        _hourSlider.alpha = 1;
        _hourSlider.clircleAlpha = 1;
        _minuteSlider.transform = CGAffineTransformMakeScale(1, 1);
        _minuteSlider.alpha = 1;
        _minuteSlider.clircleAlpha = 1;
    } completion:nil];
    
    
    
    //clocktable 消失
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _clockTableBottom.constant = -240;
        [self.showClockTable layoutIfNeeded];
    } completion:nil];

    //settingView 出现
    [UIView animateWithDuration:0.3 delay:0.0f usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _settingView.alpha =1;
        _settingViewCons.constant = 8;
        [self.settingView layoutIfNeeded];
    } completion:nil];
    //点击add，add图标消失-----
    [UIView animateWithDuration:0.5 delay:0.0  options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _addClockButton.alpha = 0;
        _timeLabel.transform =CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished){
        
        [_hourSlider move:(hour) * 30];
        [_minuteSlider move:minute * 6];
        _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)hour, (int)minute];
        
    }];
    [UILabel animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.alpha = 1;
        _checkView.alpha = 1;
        
    } completion:nil];
    [UIView animateWithDuration:2 delay:0.0  options:UIViewAnimationOptionCurveEaseOut animations:^{
        _addClockButton.transform = CGAffineTransformMakeRotation(M_PI);
        _addClockButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:nil];
    //timeLabel出现
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _timeLabel.transform =CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    //checkView出现
    [UIView animateWithDuration:0.2 delay:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //改变checkView的约束
        _checkViewbuttomCons.constant = 0;
        [self.checkView layoutIfNeeded];
    } completion:nil];

    
    //刷新UITableView
    [_showClockTable reloadData];
    
    if (tableView == _showClockTable) {
        NSLog(@"didSelectRowAtIndexPath = %ld",(long)indexPath.row);
    }
    self.navigationItem.title = @"编辑";
    // self.navigationItem.leftBarButtonItem.
    self.navigationItem.leftBarButtonItem.enabled = true;
    self.navigationItem.leftBarButtonItem.title = @"取消";
    self.navigationItem.rightBarButtonItem.enabled = false;
    self.navigationItem.rightBarButtonItem.title = @"";

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *arr = _t_array[indexPath.row];
        
        NSString * notificationMark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",arr[0], arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8],arr[9]];
        
        
        [_t_array removeObjectAtIndex:indexPath.row];
        [dataDictionary setObject:_t_array forKey:@"date"];
        //取消notification
        [self deleteNotificationWithUserInfo:notificationMark];
        //------------------
        [dataDictionary writeToFile:filePatch atomically:YES];
        // Delete the row from the data source.
        [_showClockTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark 辅助函数
-(void) deleteNotificationWithUserInfo:(NSString *)notificationMark
{
    //取消notification
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount > 0)
    {
        // 遍历找到对应nfkey和notificationtag的通知
        for (int i=0; i<acount; i++)
        {
            UILocalNotification *myUILocalNotification = [narry objectAtIndex:i];
            NSDictionary *userInfo = myUILocalNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"id"];
            if ([obj isEqualToString: notificationMark])
            {
                // 删除本地通知
                [[UIApplication sharedApplication] cancelLocalNotification:myUILocalNotification];
            }
        }
    }
}
-(void)rightCircle:(UIButton *)button
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds      byRoundingCorners:UIRectCornerBottomRight | UIRectCornerTopRight  cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}
-(void)letCircle:(UIButton *)button
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}
-(void)allCircle:(UIButton *)button
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight  cornerRadii:CGSizeMake(18, 18)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

-(void)allRect:(UIButton *)button
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft | UIRectCornerBottomRight | UIRectCornerTopRight  cornerRadii:CGSizeMake(0, 0)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = button.bounds;
    maskLayer.path = maskPath.CGPath;
    button.layer.mask = maskLayer;
}

//delayView-Function
#pragma mark delayView函数
- (IBAction)DelayCheck:(UIButton *)sender {
    if (_MusicViewTopCons.constant == -1) {
        
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _MusicViewTopCons.constant = 32;
            _changeDelayTimeSlider.alpha = 1;
            [self.MusicView layoutIfNeeded];

        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _MusicViewTopCons.constant = -1;
            _changeDelayTimeSlider.alpha = 0;
            [self.MusicView layoutIfNeeded];
            
        } completion:nil];
    }
    
    
}

- (IBAction)changeDelayTime:(UISlider *)sender {
    _showDelayTimeLabel.text = [NSString stringWithFormat:@"%d",(int)_changeDelayTimeSlider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
