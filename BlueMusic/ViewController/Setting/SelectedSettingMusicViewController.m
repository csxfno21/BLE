//
//  SelectedSettingMusicViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-3-17.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "SelectedSettingMusicViewController.h"

@interface SelectedSettingMusicViewController ()

@end

@implementation SelectedSettingMusicViewController
static NSString *cellIdentifier = @"SelectedMusic";
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"head_songselect.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.view addSubview:logo];
    
    self.view.backgroundColor = [UIColor colorWithRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
    
    [self addBackBtn];
    [self addTopLine];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 81, width, CGRectGetHeight([UIScreen mainScreen].bounds) - 81)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"音乐";
    cell.textLabel.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
