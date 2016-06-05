//
//  notificationManager.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//


#import "notificationManager.h"
#import "dateManager.h"

@implementation notificationManager

-(void)addLocalNotificationWithHour:(int) hour Minute:(int)minute Sun:(int)sun Mon:(int)mon Tue:(int)tue Wed:(int)wed Thu:(int)thu Fri:(int)fri Sat:(int)sat Delay:(int) delay
{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int nowHour = (int)[dateComponent hour];
    int nowMinute = (int)[dateComponent minute];
    //---------------
    NSNumber *hourMark = [NSNumber numberWithInt:hour];
    NSNumber *minuteMark = [NSNumber numberWithInt:minute];
    NSNumber *delayMark = [NSNumber numberWithInt:delay];
    NSNumber *sunMark = [NSNumber numberWithInt:sun];
    NSNumber *monMark = [NSNumber numberWithInt:mon];
    NSNumber *tueMakr = [NSNumber numberWithInt:tue];
    NSNumber *wedMark = [NSNumber numberWithInt:wed];
    NSNumber *thuMark = [NSNumber numberWithInt:thu];
    NSNumber *friMark = [NSNumber numberWithInt:fri];
    NSNumber *satMark = [NSNumber numberWithInt:sat];
    //
    //    int delayTime = delay;
    
    //每一个notification的id是设置的时间＋delayTime＋每个星期的mark组成的一个array
    dateManager * manager = [dateManager sharedManager];
    NSArray *arr = [[NSArray alloc] initWithObjects:hourMark, minuteMark, delayMark, sunMark, monMark, tueMakr, wedMark, thuMark, friMark, satMark,nil];
    //将arr存进notification和plist中
    
    
    NSString * notificationMark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",arr[0], arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8],arr[9]];
    NSLog(@"%@",notificationMark);
    //将时间存在array里
    manager.info = notificationMark;
    
    [manager writrDate:arr];
    
    if (sun == 0) {
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 1;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是周7的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (mon == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 2;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期一的闹钟？"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (tue == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 3;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是周三的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (wed == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 4;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期三的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (thu == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 5;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期四的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (fri == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 6;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期五的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName=@"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (sat == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 7;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        notification.repeatInterval =  NSCalendarUnitMinute;
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期六的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName=@"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(NSArray *)addButNoSaveInPlistLocalNotificationWithHour:(int) hour Minute:(int)minute Sun:(int)sun Mon:(int)mon Tue:(int)tue Wed:(int)wed Thu:(int)thu Fri:(int)fri Sat:(int)sat Delay:(int) delay
{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = kCFCalendarUnitHour | kCFCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int nowHour = (int)[dateComponent hour];
    int nowMinute = (int)[dateComponent minute];
    //--------
    NSNumber *hourMark = [NSNumber numberWithInt:hour];
    NSNumber *minuteMark = [NSNumber numberWithInt:minute];
    NSNumber *delayMark = [NSNumber numberWithInt:delay];
    NSNumber *sunMark = [NSNumber numberWithInt:sun];
    NSNumber *monMark = [NSNumber numberWithInt:mon];
    NSNumber *tueMakr = [NSNumber numberWithInt:tue];
    NSNumber *wedMark = [NSNumber numberWithInt:wed];
    NSNumber *thuMark = [NSNumber numberWithInt:thu];
    NSNumber *friMark = [NSNumber numberWithInt:fri];
    NSNumber *satMark = [NSNumber numberWithInt:sat];
    //
    //    int delayTime = delay;
    
    //每一个notification的id是设置的时间＋delayTime＋每个星期的mark组成的一个array
    NSArray *arr = [[NSArray alloc] initWithObjects:hourMark, minuteMark, delayMark, sunMark, monMark, tueMakr, wedMark, thuMark, friMark, satMark,nil];
    //将arr存进notification和plist中
    
    
    NSString * notificationMark = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",arr[0], arr[1],arr[2],arr[3],arr[4],arr[5],arr[6],arr[7],arr[8],arr[9]];
    
    if (sun == 0) {
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 1;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (mon == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 2;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期一的闹钟？"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (tue == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 3;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期二的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (wed == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 4;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期三的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (thu == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 5;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期四的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (fri == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 6;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期五的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName=@"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        
        
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (sat == 0) {
        //set
        //set
        UILocalNotification *notification=[[UILocalNotification alloc]init];
        //设置调用时间
        NSCalendar *dateCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents * dateComponents = [dateCalendar components: unitFlags fromDate:[NSDate date]];
        NSDateComponents *myCompoentes = [[NSDateComponents alloc]init];
        [myCompoentes   setYear:dateComponents.year];
        [myCompoentes   setMonth:dateComponents.month];
        [myCompoentes   setWeekday:dateComponents.weekday];
        [myCompoentes   setDay:dateComponents.day];
        [myCompoentes   setHour:hour];
        [myCompoentes   setMinute:minute];
        [myCompoentes   setSecond:0];
        int newWeekDay = 7;
        
        long int temp = 0;
        long int days = 0;
        
        temp = newWeekDay - myCompoentes.weekday;
        days = (temp > 0 ? temp : temp + 7);
        if (temp == 0) {
            if (hour >= nowHour && minute > nowMinute) {
                days = 0;
            }
            else{
                days = 7;
            }
        }
        NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:myCompoentes] dateByAddingTimeInterval:3600 * 24 * days];
        //-------------------------
        notification.fireDate = newFireDate;//通知触发的时间，10s以后
        notification.repeatInterval = NSCalendarUnitWeekOfYear;//通知重复次数
        notification.repeatInterval =  NSCalendarUnitMinute;
        
        notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
        //设置通知属性
        notification.alertBody=@"这是星期六的闹钟"; //通知主体
        notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
        //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
        notification.soundName=@"12.caf";//通知声音（需要真机才能听到声音）
        
        //设置用户信息
        notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
        //设置重复的notification
        int num = (int)(60 / delay);
        int i = 0;
        while (i < num) {
            UILocalNotification *notification=[[UILocalNotification alloc]init];
            //notification的信息
            notification.fireDate = [newFireDate dateByAddingTimeInterval:60 * delay * (i +1)];
            notification.repeatInterval = NSCalendarUnitHour;//通知重复次数
            notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
            //设置通知属性
            notification.alertBody=@"这是闹钟"; //通知主体
            notification.applicationIconBadgeNumber = 0;//应用程序图标右上角显示的消息数
            notification.alertAction = @"打开应用"; //待机界面的滑动动作提示
            notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
            //notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
            notification.soundName = @"12.caf";//通知声音（需要真机才能听到声音）
            
            //设置用户信息
            notification.userInfo = @{@"id":notificationMark};//绑定到通知上的其他附加信息
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            //
            //---
            i++;
        }
        //调用通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    return arr;
}
//存储notification
-(NSMutableArray *)returnNotificationArray
{
    return _array;
}




#pragma mark 移除本地通知，在不需要此通知时记得移除
-(void)removeNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end