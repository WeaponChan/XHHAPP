//
//  XHHReturnDetailViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHReturnDetailViewController.h"
#import "UIColor+LhkhColor.h"
#import "XHHReturnDetailTableViewCell.h"
#import "Masonry.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XHHReturnDetailModel.h"
#import "AppDelegate.h"

@interface XHHReturnDetailViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *ReturnDetailArr;
}
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSDictionary *params;
@end

@implementation XHHReturnDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"返费明细";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    [self setTableView];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1012);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); //user.integerValue
    params[@"user_id"] = @(user_id.integerValue);
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1012&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----meReturnDetail=%@",responseObject);
       
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            ReturnDetailArr = [NSMutableArray array];
            ReturnDetailArr = [XHHReturnDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            [self.tableView reloadData];
        }
        else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
            
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}
-(void)login{
    [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHReturnDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHReturnDetailTableViewCell"];
        tableView.backgroundColor = RGBA(237, 237, 237, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return ReturnDetailArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"XHHReturnDetailTableViewCell" ;
    XHHReturnDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    XHHReturnDetailModel *model = ReturnDetailArr[indexPath.section];
    cell.timeLab.text = model.rebate_time;
    cell.titleLab.text = [NSString stringWithFormat:@"编号：%@ 返费",model.order_id];
    cell.returnMLab.text = [NSString stringWithFormat:@"+%@元",model.rebate_money];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 10;
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
