//
//  GenderViewController.m
//  Morning_app
//
//  Created by LiuHaowen on 16/5/23.
//  Copyright © 2016年 LiuHaowen. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()
@property (weak, nonatomic) IBOutlet UIButton *famaleCheck;
@property (weak, nonatomic) IBOutlet UIButton *maleCheck;
@property (weak, nonatomic) IBOutlet UIImageView *famaleImage;
@property (weak, nonatomic) IBOutlet UIImageView *maleImage;

@end

@implementation GenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:85/255 green:85/255 blue:85/255 alpha:1];
    self.navigationItem.title = @"性别";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)famaleCheck:(UIButton *)sender {
    _famaleImage.image = [UIImage imageNamed:@"gou"];
    _famaleImage.alpha = 1;
    _maleImage.alpha = 0;
    
    //在userInfoPlist中写入数据
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDictionary == NULL) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"];
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    [dataDictionary setObject:@"female" forKey:@"gender"];
    //写入plist
    [dataDictionary writeToFile:filePatch atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];



}
- (IBAction)maleCheck:(UIButton *)sender {
    _maleImage.image = [UIImage imageNamed:@"gou"];
    _maleImage.alpha = 1;
    _famaleImage.alpha = 0;
    //在userInfoPlist中写入数据
    NSString *filePatch = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"userData.plist"];
    //data
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:filePatch];
    if (dataDictionary == NULL) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"userData" ofType:@"plist"];
        dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    [dataDictionary setObject:@"male" forKey:@"gender"];
    //写入plist
    [dataDictionary writeToFile:filePatch atomically:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
