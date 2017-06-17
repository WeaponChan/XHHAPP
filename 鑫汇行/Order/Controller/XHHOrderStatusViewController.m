//
//  XHHOrderStatusViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHOrderStatusViewController.h"
#import "XHHOrderTableViewCell.h"
#import "Masonry.h"
#import "LhkhAlertViewController.h"
#import "XHChatQQ.h"
#import "XHHOrderDetailViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "LhkhHttpsManager.h"
#import "XHHOrderModel.h"
#import "MBProgressHUD+Add.h"
#import "AppDelegate.h"
@interface XHHOrderStatusViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *orderList;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) NSInteger page_num;
@end

@implementation XHHOrderStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    [self loadData];
}
-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHOrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHOrderTableViewCell"];
        
        tableView.backgroundColor = RGBA(236, 236, 236, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [self loadMoreDataFooterWith:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(35);
        make.bottom.mas_equalTo(self.view).offset(-99);
    }];
    
}
-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
        [scrollView.mj_footer endRefreshing];
    }];
    
    return loadMoreFooter;
}

-(void)loadData{
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}

-(void)loadNewData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1007);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue);
    params[@"status"] = @(self.type);
    params[@"page_num"] = @(0);
    params[@"list_rows"] = @(8);
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1007&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----order=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        self.page_num = 0;
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            _orderList = [XHHOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            NSString *totalnum = responseObject[@"totalnum"];
            if ([totalnum isEqualToString:@"0"] ) {
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
                footer.stateLabel.text = @"没有更多了";
            }
            [self.tableView reloadData];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
   
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        NSString *str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"----%@",str);
        [MBProgressHUD show:str view:self.view];
    }];
}

-(void)loadMoreData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1007);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue);
    params[@"status"] = @(self.type);
    NSInteger page = self.page_num + 1;
    params[@"page_num"] = @(page);
    params[@"list_rows"] = @(8);
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1007&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----order=%@",responseObject);
        if (self.params != params) return;
        [self.tableView.mj_header endRefreshing];
        self.page_num = page;
        if ([responseObject[@"status"] isEqualToString:@"1"])
        {
            [_orderList addObjectsFromArray: [XHHOrderModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
            NSString *totalnum = responseObject[@"totalnum"];
            if ([totalnum isEqualToString:@"0"] ) {
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
                footer.stateLabel.text = @"没有更多了";
            }
            [self.tableView reloadData];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }else{
            NSString *totalnum = responseObject[@"totalnum"];
            if ([totalnum isEqualToString:@"0"] ) {
                MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
                footer.stateLabel.text = @"没有更多了";
            }
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (self.params != params) return;
        NSString *str = [NSString stringWithFormat:@"%@",error];
        NSLog(@"----%@",str);
        [MBProgressHUD show:str view:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _orderList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakself = self;
    static NSString *CellIdentifier = @"XHHOrderTableViewCell" ;
    XHHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    XHHOrderModel *model = _orderList[indexPath.section];
    cell.orderNumLab.text = [NSString stringWithFormat:@"订单编号  %@",model.order_id];
    cell.nameLab.text = [NSString stringWithFormat:@"借款人  %@",model.user_name];
    cell.phoneLab.text = [NSString stringWithFormat:@"联系电话  %@",model.phone];
    cell.applyTimeLab.text =[NSString stringWithFormat:@"申请时间  %@",model.addtime];
    float money = model.sure_money.floatValue /10000;
    cell.moneyLab.text = [NSString stringWithFormat:@"￥%.1f万",money];
    cell.companyLab.text = model.pro_name;
//    `status` 订单状态（1:待审核  2：待放款(审核通过) 3：待返点(已放款)  4：已完成(已返点) 5: 未通过(结束)
    if ([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"2"]) {
        cell.statusImg.image = [UIImage imageNamed:@"underway"];
        cell.statusLab.text = @"申请中";
        cell.statusLab.textColor = RGBA(218, 218, 218, 1);
        cell.checkImg.hidden = YES;
        cell.statusBtn.hidden = NO;
        cell.failLab.hidden = YES;
    }else if ([model.status isEqualToString:@"3"] || [model.status isEqualToString:@"4"]){
        cell.statusImg.image = [UIImage imageNamed:@"success"];
        cell.statusLab.text = @"已放款";
        cell.statusLab.textColor = RGBA(143, 249, 71, 1);
        cell.checkImg.hidden = NO;
        cell.checkImg.image = [UIImage imageNamed:@"chackSuccess"];
        cell.statusBtn.hidden = NO;
        cell.failLab.hidden = YES;
    }else{
        cell.statusImg.image = [UIImage imageNamed:@"fail-1"];
        cell.statusLab.text = @"未通过";
        cell.statusLab.textColor = [UIColor redColor];
        cell.checkImg.hidden = NO;
        cell.checkImg.image = [UIImage imageNamed:@"chackFail"];
        cell.statusBtn.hidden = YES;
        cell.failLab.hidden = NO;
        cell.failLab.text = [NSString stringWithFormat:@"未通过的原因:%@",model.refuse_reason];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderApplyStatusBlock = ^(){
        [self kefu];

    };
    return cell;
}

-(void)kefu{

    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1018);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue);
    params[@"user_id"] = @(user_id.integerValue);
    
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1018&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----kefu=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                NSDictionary *dic = responseObject[@"list"];
                NSString *namestr = dic[@"admin_name"];
                NSString *tel = dic[@"phone"];
                NSString *qq = dic[@"qq"];
                NSString *title = nil;
                title = [NSString stringWithFormat:@"客服：%@",namestr];
                LhkhAlertViewController *vc = [LhkhAlertViewController alertVcWithTitle:title message:tel AndAlertDoneAction:^(NSInteger tag) {
                    if (tag == 100) {
                        NSLog(@"------点击了取消");
                    }else if (tag == 101){
                        NSLog(@"------点击了确定");
                        NSString *phoneNum = tel;
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
                        [[UIApplication sharedApplication] openURL:url];
                    }else{
                        NSLog(@"------点击了qq客服");
                        if([XHChatQQ haveQQ])//是否有安装QQ客户端
                        {
                            
                            [XHChatQQ chatWithQQ:qq];
                        }
                        else
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备尚未安装QQ客户端,不能进行QQ临时会话" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                    }
                }];
                [self showTransparentController:vc];
            }
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XHHOrderModel *model = _orderList[indexPath.section];
    XHHOrderDetailViewController *vc = [[XHHOrderDetailViewController alloc] init];
    vc.orderID = model.order_id;
    vc.ID = model.ID;
    vc.sqMoney = model.sure_money;
    vc.status = model.status;
    [self.navigationController pushViewController:vc animated:NO];

}
-(NSMutableArray *)orderList{
    if (!_orderList) {
        _orderList = [NSMutableArray array];
    }
    return _orderList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
