//
//  ClockViewController.m
//  BlueMusic
//
//  Created by csxfno21 on 15-2-12.
//  Copyright (c) 2015年 csxfno21. All rights reserved.
//

#import "ClockViewController.h"
#define HEIGHT_CELL             50.0f
#import "ColckCell.h"
#import "EditClockViewController.h"
#import "ClockRingViewController.h"
#import "WorkTimeView.h"


@interface ClockViewController ()<ClockCellDelegate,WorkTimeViewDelegate>
{
    int selectedIndex;
    NSMutableArray *list;
    VOICE_TYPE voiceType;
    NSInteger  workTime;
    
    NSMutableArray *clockList;
    BOOL canAddClock;
    
    NSMutableArray *clockOnList;
}
@end

@implementation ClockViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTopLine];
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    UIImage *logoimage = [UIImage imageNamed:@"head_clock.png"];
    UIImageView *logo = [[UIImageView alloc] initWithImage:logoimage];
    logo.center = CGPointMake(width/2.0, 30 + logoimage.size.height/2.0);
    [self.view addSubview:logo];
    
    //添加head
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, HEIGHT_CELL)];
    headView.backgroundColor = [UIColor clearColor];
    self.mTableView.tableHeaderView = headView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 150, HEIGHT_CELL)];
    label.text = @"时间设定";
    label.font = [UIFont boldSystemFontOfSize:16.0f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
    [headView addSubview:label];
    
    UIButton *addButon = [[UIButton alloc] initWithFrame:CGRectMake(width - 25 - 20, (HEIGHT_CELL - 20)/2.0, 20, 20)];
    [addButon setImage:[UIImage imageNamed:@"btn_add_clock.png"] forState:UIControlStateNormal];
    [headView addSubview:addButon];
    [addButon addTarget:self action:@selector(addClock:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTime:) name:POST_TIME_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRing:) name:POST_RING object:nil];
    
    selectedIndex = -1;
    list = [NSMutableArray array];
    clockList = [NSMutableArray array];
    canAddClock = NO;
    clockOnList = [NSMutableArray array];
    //获取闹钟
    id obj = [[BlueToothManager sharedInstanced] loadLocalCache:@"AddClock"];
    if (obj)
    {
        clockList = (NSMutableArray *)obj;
    }
    
    //clock request
    [[BlueToothManager sharedInstanced] requestClockSetting];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

//添加一个闹钟
- (void)addClock:(id)sender
{
    canAddClock = YES;
    EditClockViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"EditClockViewController"];
    controller.canAddClock = canAddClock;
    [self.navigationController pushViewController:controller animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (clockList && clockList.count > 0)
        return [clockList count];
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
    ColckCell *cell = (ColckCell*)[tableView dequeueReusableCellWithIdentifier:indentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    NSDictionary *dic = [clockList objectAtIndex:indexPath.row];
    [cell.mColockTime setText:[dic objectForKey:[NSNumber numberWithInt:indexPath.row]]];
    
    if (cell.mSwitchActionBtn.on)
    {
        [clockOnList addObject:dic];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)setTime:(NSNotification *)noti
{
    NSString *time = (NSString *)noti.object;
    NSString *hour = [time substringToIndex:2];
    NSString *min = [time substringFromIndex:3];
    
    voiceType = 2;
    workTime = 5;
    if (!canAddClock)   //编辑闹钟
    {
        
        NSMutableDictionary *dic = [clockList objectAtIndex:selectedIndex];
        [dic setObject:time forKey:[NSNumber numberWithInt:selectedIndex]];
        ColckCell *cell = (ColckCell *)[self.mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        [cell.mColockTime setText:time];
        [[BlueToothManager sharedInstanced] requestAddClock:selectedIndex withHour:[hour integerValue] withMinute:[min integerValue] withVoiceType:voiceType withWorkTime:workTime];
    }
    else    //添加一个闹钟
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:time forKey:[NSNumber numberWithInt:clockList.count]];
        [clockList addObject:dic];
        [[BlueToothManager sharedInstanced] addCache2local:clockList withKey:@"AddClock"];
        [self.mTableView reloadData];
        [[BlueToothManager sharedInstanced] requestAddClock:clockList.count withHour:[hour integerValue] withMinute:[min integerValue] withVoiceType:voiceType withWorkTime:workTime];
    }
    
}

#pragma mark - clock delegate
-(void)colckCell:(ColckCell *)cell canEditClock:(BOOL)isCan
{
    canAddClock = NO;
    selectedIndex = cell.tag;
    EditClockViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"EditClockViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)colckCell:(ColckCell *)cell isOn:(BOOL)isOn withIndex:(int)index
{
    if (isOn)   //开启闹钟
    {
        NSDictionary *dic = [clockList objectAtIndex:index];
        NSString *hour = [[dic objectForKey:[NSNumber numberWithInt:index]] substringToIndex:2];
        NSString *min = [[dic objectForKey:[NSNumber numberWithInt:index]] substringFromIndex:3];
        [[BlueToothManager sharedInstanced] addCache2local:clockList withKey:@"AddClock"];
        [[BlueToothManager sharedInstanced] requestAddClock:selectedIndex withHour:[hour integerValue] withMinute:[min integerValue] withVoiceType:voiceType withWorkTime:workTime];
        if (![clockOnList containsObject:dic])
        {
            [clockOnList addObject:dic];
        }
    }
    else    //关闭闹钟
    {
        [[BlueToothManager sharedInstanced] requestAddClock:selectedIndex withHour:24 withMinute:0 withVoiceType:voiceType withWorkTime:workTime];
    }
}

- (IBAction)choseRingAction:(id)sender
{
    ClockRingViewController *controller = [[UIStoryboard storyboardWithName:@"MusicViewController" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ClockRingViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setRing:(NSNotification *)noti
{
    NSString *ring = noti.object;
    [self.mRingLabel setText:ring];
    
    for (int i = 0; i < clockOnList.count ; i++)
    {
        voiceType = i;
        NSDictionary *dic = [clockOnList objectAtIndex:i];
        NSString *hour = [[dic objectForKey:[NSNumber numberWithInt:i]] substringToIndex:2];
        NSString *min = [[dic objectForKey:[NSNumber numberWithInt:i]] substringFromIndex:3];
        [[BlueToothManager sharedInstanced] addCache2local:clockList withKey:@"AddClock"];
        [[BlueToothManager sharedInstanced] requestAddClock:selectedIndex withHour:[hour integerValue] withMinute:[min integerValue] withVoiceType:voiceType withWorkTime:[self.workTimeLabel.text integerValue]];
    }
}

- (IBAction)setWorkTime:(id)sender
{
    self.ringBtn.userInteractionEnabled = YES;
    BOOL hasView = NO;
    for (UIView *view in self.view.subviews)
    {
        if (view.tag == 1000)
        {
            [view removeFromSuperview];
            hasView = YES;
            break;
        }
    }
    
    if (hasView)
    {
        
    }
    else
    {
        self.ringBtn.userInteractionEnabled = NO;
        //POPView  选择工作时间
        WorkTimeView *workTimeView = [[[UINib nibWithNibName:@"WorkTimeView" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
        workTimeView.frame = CGRectMake(230 + 1, self.workTimeLabel.frame.origin.y - 73 + 35                                                                                                                                                                                                                                                       , 30, 60);
        workTimeView.backgroundColor = [UIColor clearColor];
        workTimeView.delegate = self;
        workTimeView.tag = 1000;
        [self.view addSubview:workTimeView];
    }
}

-(void)workTimeView:(WorkTimeView *)workTimeView withString:(NSString *)str
{
    [self.workTimeLabel setText:str];
    for (int i = 0; i < clockOnList.count ; i++)
    {
        NSDictionary *dic = [clockOnList objectAtIndex:i];
        NSString *hour = [[dic objectForKey:[NSNumber numberWithInt:i]] substringToIndex:2];
        NSString *min = [[dic objectForKey:[NSNumber numberWithInt:i]] substringFromIndex:3];
        [[BlueToothManager sharedInstanced] requestAddClock:selectedIndex withHour:[hour integerValue] withMinute:[min integerValue] withVoiceType:voiceType withWorkTime:[self.workTimeLabel.text integerValue]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:POST_TIME_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:POST_RING object:nil];
}
@end
