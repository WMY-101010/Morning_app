//
//  dateManager.h
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface dateManager : NSObject
@property (nonatomic, copy) NSString * info;
@property (nonatomic) NSMutableArray *array;


+(dateManager *)sharedManager;
-(void)writrDate:(NSArray *)date;
-(void) changeDataWithData:(NSArray *)data atRow:(NSInteger) row;
@end

