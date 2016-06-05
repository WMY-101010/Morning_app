//
//  SettingViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/23.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "SettingViewController.h"
#import "GenderViewController.h"
#import "LocationViewController.h"
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *arr;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *gender;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
    
    
    _arr = [NSMutableArray arrayWithObjects:
            [NSMutableArray arrayWithObjects:@"性别", @"地点",nil],
            [NSMutableArray arrayWithObjects:@"给我们评价", @"您的意见",@"关于我们",nil],
            nil];

    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    //获取到字典中的数据
    //在plist中获取数据并跟新UI
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    _cityName = [dataDictionary objectForKey:@"city"];
    _gender = [dataDictionary objectForKey:@"gender"];
    NSLog(@"_gender = %@",_gender);
    [self.tableView reloadData];
}

//uitable代理
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else
    {
        return 3;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"个人设置";
    }
    else
    {
        return @"其他";
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"点击了性别");
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        GenderViewController *genderVC = (GenderViewController*)[storyboard instantiateViewControllerWithIdentifier:@"gender"];
        
        [self.navigationController pushViewController:genderVC animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"点击地点");
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
         LocationViewController *locationVC = (LocationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"location"];
        
        [self.navigationController pushViewController:locationVC animated:YES];
    }

}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell的重用标志
    //从重用队列中取出cell
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1002];
    label.text =  [NSString stringWithFormat:@"%@", [[_arr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    UILabel *cityLabel = (UILabel *)[cell.contentView viewWithTag:1003];
    UIImageView *genderimage = (UIImageView *)[cell.contentView viewWithTag:1001];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([_gender isEqualToString:@"female"]) {
            genderimage.image = [UIImage imageNamed:@"ic_female_big"];
        }
        else
        {
            genderimage.image = [UIImage imageNamed:@"ic_male_big"];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cityLabel.text = _cityName;
    }

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
