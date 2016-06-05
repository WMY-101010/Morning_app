//
//  dateManager.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/21.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//


#import "dateManager.h"

@implementation dateManager
@synthesize array = _array;

+(dateManager *)sharedManager
{
    static dateManager *dateManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateManager = [[self alloc] init];
    });
    return  dateManager;
}


-(void)writrDate:(NSArray *)date
{
    //    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"date" ofType:@"plist"];
    //    NSLog(@"这是plist文件的路径%@", plistPath);
    //    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    //    NSLog(@"这是plist文件的内容%@", data);
    //    NSLog(@"writrDate");
    //plist
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    NSLog(@"filePatch = %@",filePatch);
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDictionary == NULL) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"date" ofType:@"plist"];
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    if (_array == nil) {
        _array = [[NSMutableArray alloc]init];
        _array = [dataDictionary objectForKey:@"date"];
        [_array addObject:date];
    }
    else
    {
        _array = [dataDictionary objectForKey:@"date"];
        [_array addObject:date];
    }
    [dataDictionary setObject:_array forKey:@"date"];
    //写入plist里面
    [dataDictionary writeToFile:filePatch atomically:YES];
    
}

-(void) changeDataWithData:(NSArray *)data atRow:(NSInteger) row
{
    
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"date.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDictionary == NULL) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"date" ofType:@"plist"];
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    if (_array == nil) {
        _array = [[NSMutableArray alloc]init];
        _array = [dataDictionary objectForKey:@"date"];
        
        [_array replaceObjectAtIndex:row withObject:data];
    }
    else
    {
        _array = [dataDictionary objectForKey:@"date"];
        
        [_array replaceObjectAtIndex:row withObject:data];
    }
    
    [dataDictionary setObject:_array forKey:@"date"];
    //写入plist里面
    [dataDictionary writeToFile:filePatch atomically:YES];
}



@end