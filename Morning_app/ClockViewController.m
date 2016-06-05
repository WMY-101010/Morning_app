//
//  ClockViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/24.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "ClockViewController.h"
#import "SleepViewController.h"
#import "ShowWeatherViewController.h"

@interface ClockViewController ()
@property (weak, nonatomic) IBOutlet UIView *coverVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coverHeightCons;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;


@property (nonatomic) CGPoint beginPoint;
@property (nonatomic) CGPoint lostPoint;


@end

static CGFloat coverViewHeight;
static CGFloat height;
static CGFloat timeLabelPointY;
@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //显示时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
        _TimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)hour, (int)minute];
    //在plist中获取数据，更新UI
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    NSString *gender = [dataDictionary objectForKey:@"gender"];
    if ([gender isEqualToString:@"male"] || gender == nil) {
        _image.image = [UIImage imageNamed:@"boy"];
    }
    else
    {
        _image.image = [UIImage imageNamed:@"girl"];
    }
    
    _TimeLabel.userInteractionEnabled = YES;
    
    coverViewHeight = _coverHeightCons.constant;
    height = self.view.frame.size.height;
    timeLabelPointY = self.TimeLabel.frame.origin.y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _beginPoint = [[touches anyObject] locationInView:_TimeLabel]; //记录第一个点，以便计算移动距离
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // Move relative to the original touch point
    // 计算移动距离，并更新图像的frame
    CGPoint pt = [[touches anyObject] locationInView:_TimeLabel];
    CGRect frame = [_TimeLabel frame];
    frame.origin.y += pt.y - _beginPoint.y;
    [_TimeLabel setFrame:frame];
    _coverHeightCons.constant = height - _TimeLabel.frame.origin.y;
        _coverVIew.alpha = 0.3 + (height - _TimeLabel.frame.origin.y) / self.view.frame.size.height;
//    NSLog(@"_quiltView.alpha  = %f",_coverVIew.alpha);
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGFloat nowtimeLabelHeight = height - _TimeLabel.frame.origin.y;
    
    if (nowtimeLabelHeight < coverViewHeight)
    {
        if (nowtimeLabelHeight < 200) {
            CGRect rect = _TimeLabel.frame;
            rect.origin.y = 0;
            [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _TimeLabel.frame = rect;
                _coverHeightCons.constant = 0;
                [self.coverVIew layoutIfNeeded];
            } completion:^(BOOL finished){
            
            
            }];
            
            
            //push到天气的View
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ShowWeatherViewController *weatherVC = (ShowWeatherViewController*)[storyboard instantiateViewControllerWithIdentifier:@"weather"];
            
             [self presentViewController:weatherVC animated:YES completion:nil];
            //如果偏移的距离距离上部小于100 pushToDelayView

        }
        if (nowtimeLabelHeight > 200)
        {
            //回到原来的位置
            //timeLabelh和qulitView回到原始状态
            CGRect rect = _TimeLabel.frame;
            rect.origin.y = timeLabelPointY;
            [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _TimeLabel.frame = rect;
                _coverHeightCons.constant = coverViewHeight;
                [self.coverVIew layoutIfNeeded];
            } completion:nil];
        }
    }
    else
    {
        int dis = self.view.frame.size.height - 200;
        if (nowtimeLabelHeight < dis)
        {
            //timeLabelh和qulitView回到原始状态
            CGRect rect = _TimeLabel.frame;
            rect.origin.y = timeLabelPointY;
            [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _TimeLabel.frame = rect;
                _coverHeightCons.constant = coverViewHeight;
                [self.coverVIew layoutIfNeeded];
            } completion:nil];
            

        }
        else
        {
            [UIView animateWithDuration:0.4 delay:0.0f usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect rect = _TimeLabel.frame;
                rect.origin.y = 0;
                _coverHeightCons.constant = height;
                _TimeLabel.frame = rect;
                [self.coverVIew layoutIfNeeded];
            } completion:^(BOOL finished){
            //                [self presentViewController:sleepVC animated:NO completion:nil];
            
            }];
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            SleepViewController *sleepVC = (SleepViewController*)[storyboard instantiateViewControllerWithIdentifier:@"sleep"];
            [self presentViewController:sleepVC animated:YES completion:nil];
            //


            

           
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
