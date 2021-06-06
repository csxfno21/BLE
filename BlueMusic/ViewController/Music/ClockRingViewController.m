//
//  ClockRingViewController.m
//  BlueMusic
//
//  Created by company on 15-4-2.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "ClockRingViewController.h"
#import "RingCell.h"
#define HEIGHT_CELL             50.0f

@interface ClockRingViewController ()
{
    NSMutableArray *ringList;
}
@end

@implementation ClockRingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTopLine];
    
    ringList = [NSMutableArray array];
    for (int i = 0; i < 5; i ++)
    {
        NSString *ring = [NSString stringWithFormat:@"%@%d",@"铃声",i];
        [ringList addObject:ring];
    }
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ringList && ringList.count > 0)
        return [ringList count];
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_CELL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"ColckCell";
    RingCell *cell = (RingCell*)[tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell.ringTitleLabel setText:[ringList objectAtIndex:indexPath.row]];
    return cell;
}

//选择铃音
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:POST_RING object:[ringList objectAtIndex:indexPath.row]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


@end
