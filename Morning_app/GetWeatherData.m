//
//  GetWeatherData.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/25.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "GetWeatherData.h"

@interface GetWeatherData () <NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic) NSMutableDictionary *api;
@property (nonatomic) NSMutableDictionary *basic;
@property (nonatomic) NSMutableArray *daily_forecast;

@end
@implementation GetWeatherData


//
-(BOOL) getDataFromServer
{
    //在plist获取城市名
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    NSString *city = [dataDictionary objectForKey:@"city"];
        NSMutableString *ms = [[NSMutableString alloc] initWithString:city];
        if ([city length]) {
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            }
        }
        NSString *cityName = [NSString stringWithString:ms];
        cityName = [cityName stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"ms = %@",cityName);
    __block BOOL result = false;
    NSString *str = [NSString stringWithFormat:@"http://apis.baidu.com/heweather/weather/free?city=%@",cityName];
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"835a80fa940526bbe99e162d6555c59a" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //
        if (response == NULL) {
            NSLog(@"没有网络");
        }
        else
        {
            result = true; // true 表示有返回结果；false表示没有返回结果
            [self URLSession:session dataTask:task didReceiveData:data];
            
        }
    }];
    [task resume];
    return result;
}
-(void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray *allData = [dic objectForKey:@"HeWeather data service 3.0"];
    dic = allData[0];
    NSMutableArray *dickeyValue = [[NSMutableArray alloc] init];
    NSEnumerator *enumerator = [dic keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        [dickeyValue addObject:key];
    }
    self.api = [dic objectForKey:dickeyValue[4]];
    self.basic = [dic objectForKey:dickeyValue[5]];
    self.daily_forecast = [dic objectForKey:dickeyValue[2]];
    
    NSString *str = [self.basic objectForKey:@"city"];
    
    //day1
    NSString *daydate = [self.daily_forecast[0] objectForKey:@"date"];
    NSDictionary *day1 = self.daily_forecast[0];
    NSDictionary *day1_tmp = [day1 objectForKey:@"tmp"];
    NSString *day1_max_tmp = [day1_tmp objectForKey:@"max"];
    NSString *day1_min_tmp = [day1_tmp objectForKey:@"min"];
    NSDictionary *day1_cond = [day1 objectForKey:@"cond"];
    NSString *day1_cond_d = [day1_cond objectForKey:@"txt_d"];
    
    NSDictionary *day1data = [NSDictionary dictionaryWithObjectsAndKeys:day1_max_tmp, @"tmp_max", day1_min_tmp,@"tmp_min",day1_cond_d,@"cond", nil];
    //day2
    NSDictionary *day2 = self.daily_forecast[1];
    NSDictionary *day2_tmp = [day2 objectForKey:@"tmp"];
    NSString *day2_max_tmp = [day2_tmp objectForKey:@"max"];
    NSString *day2_min_tmp = [day2_tmp objectForKey:@"min"];
    NSDictionary *day2_cond = [day2 objectForKey:@"cond"];
    NSString *day2_cond_d = [day2_cond objectForKey:@"txt_d"];
    
    NSDictionary *day2data = [NSDictionary dictionaryWithObjectsAndKeys:day2_max_tmp, @"tmp_max", day2_min_tmp,@"tmp_min",day2_cond_d,@"cond", nil];
    //day3
    NSDictionary *day3 = self.daily_forecast[2];
    NSDictionary *day3_tmp = [day3 objectForKey:@"tmp"];
    NSString *day3_max_tmp = [day3_tmp objectForKey:@"max"];
    NSString *day3_min_tmp = [day3_tmp objectForKey:@"min"];
    NSDictionary *day3_cond = [day3 objectForKey:@"cond"];
    NSString *day3_cond_d = [day3_cond objectForKey:@"txt_d"];
    
    NSDictionary *day3data = [NSDictionary dictionaryWithObjectsAndKeys:day3_max_tmp, @"tmp_max", day3_min_tmp,@"tmp_min",day3_cond_d,@"cond", nil];
    //day4
    NSDictionary *day4 = self.daily_forecast[3];
    NSDictionary *day4_tmp = [day4 objectForKey:@"tmp"];
    NSString *day4_max_tmp = [day4_tmp objectForKey:@"max"];
    NSString *day4_min_tmp = [day4_tmp objectForKey:@"min"];
    NSDictionary *day4_cond = [day4 objectForKey:@"cond"];
    NSString *day4_cond_d = [day4_cond objectForKey:@"txt_d"];
    
    NSDictionary *day4data = [NSDictionary dictionaryWithObjectsAndKeys:day4_max_tmp, @"tmp_max", day4_min_tmp,@"tmp_min",day4_cond_d,@"cond", nil];
    
    //将数据写入plist中
    //1.拿到plist
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"weatherdata.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDictionary == NULL) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"weatherdata" ofType:@"plist"];
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    //2.将数据存入字典
    //存日期
    [dataDictionary setObject:str forKey:@"city"];
    [dataDictionary setObject:daydate forKey:@"date"];
    [dataDictionary setObject:day1data forKey:@"day1"];
    [dataDictionary setObject:day2data forKey:@"day2"];
    [dataDictionary setObject:day3data forKey:@"day3"];
    [dataDictionary setObject:day4data forKey:@"day4"];
    
    
    //写入plist里面
    [dataDictionary writeToFile:filePatch atomically:YES];
    NSLog(@"dataDictionary = %@",dataDictionary);
    NSLog(@"%@",str);
}
@end