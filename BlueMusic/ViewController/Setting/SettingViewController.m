//
//  SettingViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "SettingViewController.h"
#import "FunctionSettingViewController.h"
#import "TMPCheckViewController.h"
#import "BuyViewController.h"
@interface SettingViewController ()
@property(nonatomic,strong)NSArray *lists;
@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"head_Function setting.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.view addSubview:logo];
    [self addBackBtn];
    [self addTopLine];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:view];
    self.lists = @[@"功能设置",@"飞锐官网",@"购买配件",@"使用说明",@"软件版本"];
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
{   static NSString *identifier = @"CustomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    cell.textLabel.text = self.lists[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            FunctionSettingViewController *controller = [[UIStoryboard storyboardWithName:@"SettingViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FunctionSettingViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:
        {
            BuyViewController *controller = [[UIStoryboard storyboardWithName:@"SettingViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BuyViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
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
