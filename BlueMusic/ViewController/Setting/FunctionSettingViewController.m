//
//  FunctionSettingViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "FunctionSettingViewController.h"
#import "FunctionCell.h"
#import "TMPCheckViewController.h"
#import "SelectedSettingMusicViewController.h"
@interface FunctionSettingViewController ()
@property(nonatomic,strong)NSArray *lists;
@end

@implementation FunctionSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addTopLine];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:view];
    self.lists = @[@"开启/关闭Music Air+功能",@"自动开启/关闭净化功能",@"开启/关闭蓝牙免提电话功能",@"开启/关闭负离子功能",@"选择开机音乐",@"音效设置"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   static NSString *identifier = @"FunctionCell";
    FunctionCell *cell = (FunctionCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    cell.textLabel.text = self.lists[indexPath.row];
    if (indexPath.row == self.lists.count - 1 || indexPath.row == self.lists.count - 2)
    {
        cell.mSwitch.hidden = YES;
    }
    else
    {
        cell.mSwitch.hidden = NO;
    }
    if (indexPath.row == 1)
    {
        [cell.mSwitch setOn:NO];
    }
    else if (indexPath.row == 3)
    {
        [cell.mSwitch setOn:NO];
    }
    else
    {
        [cell.mSwitch setOn:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.lists.count - 1)
    {
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"SettingViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SoundSettingViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == self.lists.count - 2)
    {
        SelectedSettingMusicViewController *controller = [[SelectedSettingMusicViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
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
