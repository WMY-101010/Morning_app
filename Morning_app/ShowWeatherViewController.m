//
//  ShowWeatherViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/25.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "ShowWeatherViewController.h"

@interface ShowWeatherViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (copy, nonatomic) NSMutableString * cond;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (copy, nonatomic) NSString * maxTemp;
@property (copy, nonatomic) NSString * minTemp;
@property (weak, nonatomic) IBOutlet UILabel *condState;
@property (weak, nonatomic) IBOutlet UIButton *turnToMainView;

@property (nonatomic) NSMutableDictionary *dayDic;


@end

@implementation ShowWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view from its nib.
    NSDictionary *dic = [self getDataFromPlist];
    NSString *city = [dic objectForKey:@"city"];
    NSString *date = [dic objectForKey:@"date"];
    //获取date判断plist中存的是不是当天的信息
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSUInteger year = [dateComponent year];
    NSUInteger month = [dateComponent month];
    NSUInteger day = [dateComponent day];
    NSArray *arr = [date componentsSeparatedByString:@"-"];
    NSUInteger dy = [arr[0] intValue];
    NSUInteger dm = [arr[1] intValue];
    NSUInteger dd = [arr[2] intValue];
    if (dy != year || month != dm || (day - dd) > 3) {
        //plist的数据需要更新
    }
    else
    {
        //判断存取哪天天气数据
        int value = (int)(day - dd);
        NSString *st = [NSString stringWithFormat:@"day%d",value +1];
        _dayDic = [dic objectForKey:st];
    }
    //更新UI
    _cityLabel.text = city;
    _cond = [_dayDic objectForKey:@"cond"];
    _maxTemp = [_dayDic objectForKey:@"tmp_max"];
    _minTemp = [_dayDic objectForKey:@"tmp_min"];
    _condState.text = _cond;
    _temperature.text = [NSString stringWithFormat:@"%@ ºC／%@ ºC",_maxTemp, _minTemp];
    
//    _condLabel.text = [_dayDic objectForKey:@"cond"];
//    _maxTmpLabel.text = [NSString stringWithFormat:@"最高温：%@", [_dayDic objectForKey:@"tmp_max"]];
//    _minTmpLabel.text = [NSString stringWithFormat:@"最低温：%@", [_dayDic objectForKey:@"tmp_min"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)turnToMainView:(UIButton *)sender {
    
    NSLog(@"turnToMainView");
    UIStoryboard* storyboard2 = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *mainVC = (UINavigationController*)[storyboard2 instantiateViewControllerWithIdentifier:@"naviVC"];
    [self presentViewController:mainVC animated:YES completion:nil];
}

//在plist中取出数据
-(NSDictionary *) getDataFromPlist
{
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"weatherdata.plist"];
    //data
    NSDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    return dataDictionary;
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
