//
//  notificationManager.h
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface notificationManager : NSObject
@property (nonatomic, copy) NSMutableArray *array;
//@property (nonatomic) UILocalNotification *notification;


-(NSMutableArray *)returnNotificationArray;
-(void)addLocalNotificationWithHour:(int) hour Minute:(int)minute Sun:(int)sun Mon:(int)mon Tue:(int)tue Wed:(int)wed Thu:(int)thu Fri:(int)fri Sat:(int)sat Delay:(int) delay;
-(NSArray *)addButNoSaveInPlistLocalNotificationWithHour:(int) hour Minute:(int)minute Sun:(int)sun Mon:(int)mon Tue:(int)tue Wed:(int)wed Thu:(int)thu Fri:(int)fri Sat:(int)sat Delay:(int) delay;

-(void)removeNotification;

@end
