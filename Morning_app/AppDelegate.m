//
//  AppDelegate.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "AppDelegate.h"
#import "ClockViewController.h"
#import "notificationManager.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //当通告通知进入app时，跳转到闹钟画面
    
    NSLog(@"didFinishLaunchingWithOptions");
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification) {
        NSLog(@"isLaunchedNotByNotification");
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClockViewController *clockVC = (ClockViewController*)[storyboard instantiateViewControllerWithIdentifier:@"clock"];
        self.window.rootViewController = clockVC;
        [self changeNotification:notification];
    }
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
    }
    else{
        //        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge | UIUserNotificationTypeSound  categories:nil]];
        // 注册本地通知类型
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"didReceiveLocalNotification");
    if (notification) {
        NSLog(@"isLaunchedNotByNotification");
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ClockViewController *clockVC = (ClockViewController*)[storyboard instantiateViewControllerWithIdentifier:@"clock"];
        self.window.rootViewController = clockVC;
    }
    
    [self changeNotification:notification];
   
}

-(void) changeNotification:(UILocalNotification *)notification
{
    // 当点击notification会调用这个方法，在这里取消的notification，在添加下一次的notification；
    
    NSString *notificationMark = [notification.userInfo objectForKey:@"id"];
    NSArray *arr = [notificationMark componentsSeparatedByString:@","];
    NSArray *narry=[[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger acount=[narry count];
    if (acount>0)
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
    
    //添加下一次的notification
    notificationManager *manager = [[notificationManager alloc] init];
    int hour = [arr[0] intValue];
    int minute = [arr[1] intValue];
    int delay = [arr[2] intValue];
    int sun = [arr[3] intValue];
    int mon = [arr[4] intValue];
    int tue = [arr[5] intValue];
    int wed = [arr[6] intValue];
    int thu = [arr[7] intValue];
    int fri = [arr[8] intValue];
    int sat = [arr[9] intValue];
    
    [manager addButNoSaveInPlistLocalNotificationWithHour:hour Minute:minute Sun:sun Mon:mon Tue:tue Wed:wed Thu:thu Fri:fri Sat:sat Delay:delay];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
