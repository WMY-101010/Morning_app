//
//  LocationViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/24.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic,copy) NSMutableArray *cityDic;
@property (weak, nonatomic) IBOutlet UISearchBar *search;

@property (nonatomic) NSMutableArray *data;
@property (nonatomic) NSMutableArray *order;
@property (nonatomic,copy) NSString *city;

@property (nonatomic, assign) NSIndexPath * currentIndex;

@end

@implementation LocationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
    self.navigationItem.title = @"地点";

    _data = [[NSMutableArray alloc] init];
    _order = [[NSMutableArray alloc] init];
    _table.delegate = self;
    _table.dataSource = self;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    _cityDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    _search.placeholder = @"请输入城市";

    _search.delegate = self;
    _table.backgroundColor = [UIColor clearColor];

    [self.table.tableHeaderView setFrame:CGRectMake(0.0f, 0.0f, self.table.bounds.size.width, 0.01f)];

    
    [self getOrderFromData];
}



-(void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");

}
-(void) getOrderFromData
{
    //获取plist中的数据，并获取到每个city的order
    for (int i = 0; i < (int)_cityDic.count; i++)
    {
        NSDictionary *dic = _cityDic[i];
        NSArray *arr = [dic objectForKey:@"Cities"];
        for (int j = 0; j < (int)arr.count; j++) {
            //
            NSDictionary *cdic = arr[j];
            NSString *cityName = [NSString stringWithFormat:@"%@",[cdic objectForKey:@"city"]];
            NSString *city = [cityName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [_data addObject:city];
            NSString * str = [NSString stringWithFormat:@"%d-%d", i, j];
            [_order addObject:str];
        }
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BOOL mark = true;
    NSString *str2 = [_search.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    for (int i = 0; i < _data.count; i ++) {
        if ([str2 isEqualToString: _data[i]]) {
            NSLog(@"target city = %@",_data[i]);
            NSArray *arr = [_order[i] componentsSeparatedByString:@"-"];
            NSInteger section = [arr[0] intValue];
            NSInteger row = [arr[1] intValue];
            
            //            //UITableView跳转至相应位置
            [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            mark = false;
        }
    }
    
    //    NSLog(@"i = %@",_data[i]);
    
    if (mark == true) {
    }
    [_search resignFirstResponder];
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    NSDictionary *dic = _cityDic[section];
    NSString *State = [dic objectForKey:@"State"];
    
    return State;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath = %@",indexPath);
    NSDictionary *dic = _cityDic[indexPath.section];
    NSArray *arr = [dic objectForKey:@"Cities"];
    NSDictionary *cdic = arr[indexPath.row];
    NSString *cityName = [cdic objectForKey:@"city"];
    _city = cityName;
    _currentIndex = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //在userInfoPlist中写入数据
    if (_city != nil) {
        NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
        //data
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
        if (dataDictionary == NULL) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"];
            dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        }
        [dataDictionary setObject:_city forKey:@"city"];
        //写入plist
        [dataDictionary writeToFile:filePatch atomically:YES];
        
    }

    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 30;
}// Default is 1 if not implemented

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = _cityDic[section];
    
    NSArray *cityNum = [dic objectForKey:@"Cities"];
    return cityNum.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentify = @"cell";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:cellidentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentify];
    }
    //
    NSDictionary *dic = _cityDic[indexPath.section];
    NSArray *arr = [dic objectForKey:@"Cities"];
    NSDictionary *cdic = arr[indexPath.row];
    NSString *cityName = [cdic objectForKey:@"city"];
    cell.textLabel.text = cityName;
    return cell;
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
