//
//  XHHMeViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMeViewController.h"
#import "Masonry.h"
#import "XHHMeTableViewCell.h"
#import "UIImage+LhkhExtension.h"
#import "XHHAboutUsViewController.h"
#import "XHHConnctUsViewController.h"
#import "XHHMyHistoryOrderViewController.h"
#import "XHHMyTermViewController.h"
#import "XHHInvitefriViewController.h"
#import "XHHMyCardViewController.h"
#import "XHHReturnDetailViewController.h"
#import "XHHMyInfoViewController.h"
#import "AppDelegate.h"
#import "LhkhBaseNavigationViewController.h"
#import "XHHLogOutTableViewCell.h"
#import "LhkhAlertViewController.h"
#import "XHChatQQ.h"
#import "XHHMessageViewController.h"
#import "XHHHelpViewController.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UITabBarController+XHHTabarBadge.h"
@interface XHHMeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *headview;
    UIImageView *headViewBg;
    UIImageView *headImg;
    UIImageView *rightImg;
    UILabel *nameLab;
    UILabel *returnCashLab;
    UILabel *messageLab;
    UIButton *returnDetailBtn;
    UIView *bottomview;
    UIButton *logOutBtn;
    NSDictionary *headerinfoDic;
    NSString *Messagenum;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation XHHMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildheadView];
    [self setupBottomView];
    [self setTableView];
    [self loadMessageNum];
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1011);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); //user.integerValue
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1011&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----me=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            headerinfoDic = responseObject[@"list"];
            [headImg sd_setImageWithURL:[NSURL URLWithString:headerinfoDic[@"pic"]] placeholderImage:[UIImage imageNamed:@"default"]];
            headImg.layer.borderColor = [UIColor whiteColor].CGColor;
            headImg.layer.borderWidth = 2.f;
            nameLab.text = headerinfoDic[@"name"];
            NSString *str = [NSString stringWithFormat:@"累计返费  %@ (元)",headerinfoDic[@"rebate_money"]];
            NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
            NSRange rangel = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(6, str.length-10)]];
            [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
            [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:rangel];
            
            [returnCashLab setAttributedText:textColor];
            
            [self.tableView reloadData];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
        }else{
            returnCashLab.text  = @"累计返费";
            headImg.image = [UIImage imageNamed:@"default"];
            headImg.layer.borderColor = [UIColor whiteColor].CGColor;
            headImg.layer.borderWidth = 2.f;
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

-(void)loadMessageNum{
    messageLab = [[UILabel alloc]initWithFrame:CGRectZero];
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"User"];
    params[@"action"] = @(1015);
    params[@"user_id"] = @(1); //user.integerValue
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1015&do=1",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----menum=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            Messagenum = responseObject[@"list"][@"nums"];
            [self.tableView reloadData];
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

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHMeTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"XHHLogOutTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHLogOutTableViewCell"];
        tableView.backgroundColor = RGBA(236, 236, 236, 1);
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
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-54);
    }];
    
}

-(void)buildheadView{
    headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170)];
    headViewBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headview.frame.size.width, 120)];
    headViewBg.image = [UIImage imageNamed:@"meHeadBg"];
    [headview addSubview:headViewBg];
    
    headImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImg.layer.cornerRadius = 30.f;
    headImg.layer.masksToBounds = YES;
    
    [headview addSubview:headImg];
    
    nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
//    nameLab.text = @"苏有朋";
    nameLab.textColor = [UIColor whiteColor];
    [headview addSubview:nameLab];
    
    rightImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    rightImg.image  = [UIImage imageNamed:@"xiayiye_arrow"];
    [headview addSubview:rightImg];
    
    UIButton *userBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [userBtn addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:userBtn];
    
    returnCashLab = [[UILabel alloc] initWithFrame:CGRectZero];
    returnCashLab.font = [UIFont systemFontOfSize:14];
    NSString *str = @"累计返费  10000000 (元)";
    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange rangel = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(6, str.length-10)]];
    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:rangel];
    
    [returnCashLab setAttributedText:textColor];
    [headview addSubview:returnCashLab];
    
    UIView *aview = [[UIView alloc] initWithFrame:CGRectZero];
    aview.backgroundColor = [UIColor grayColor];
    [headview addSubview:aview];
    
    returnDetailBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [returnDetailBtn setTitle:@"返费明细" forState:UIControlStateNormal];
    returnDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [returnDetailBtn addTarget:self action:@selector(returnDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [returnDetailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headview addSubview:returnDetailBtn];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60);
        make.left.mas_equalTo(headview).offset(20);
        make.centerY.mas_equalTo(headViewBg);
    }];
    
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headImg.mas_right).offset(10);
        make.centerY.mas_equalTo(headImg);
    }];
    
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(18);
        make.centerY.mas_equalTo(headImg);
        make.right.mas_equalTo(headview.mas_right).offset(-10);
    }];
    
    [returnCashLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(headview).offset(20);
        make.top.mas_equalTo(headViewBg.mas_bottom).offset(10);
        make.bottom.mas_equalTo(headview.mas_bottom).offset(-10);
    }];
    
    [aview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(headViewBg.mas_bottom).offset(5);
        make.bottom.mas_equalTo(headview.mas_bottom).offset(-5);
//        make.left.mas_equalTo(returnCashLab.mas_right).offset(20);
    }];

    [returnDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(aview.mas_right).offset(25);
        make.right.mas_equalTo(headview.mas_right).offset(-20);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(headViewBg.mas_bottom).offset(10);
        make.bottom.mas_equalTo(headview.mas_bottom).offset(-10);
    }];
    
    [userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(headViewBg).offset(0);
    }];
}

-(void)setupBottomView{
    bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 85)];
    bottomview.backgroundColor = RGBA(236, 236, 236, 1);
    logOutBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    logOutBtn.backgroundColor = [UIColor redColor];
    [logOutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    logOutBtn.layer.cornerRadius = 4.f;
    logOutBtn.layer.masksToBounds = YES;
    [logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logOutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:logOutBtn];
    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomview ).offset(45);
        make.left.mas_equalTo(bottomview).offset(20);
        make.right.mas_equalTo(bottomview).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
}

-(void)userInfoClick{
    XHHMyInfoViewController *vc =[[XHHMyInfoViewController alloc]init];
    [self transformView:vc];
}

-(void)returnDetailClick{
    XHHReturnDetailViewController *vc = [[XHHReturnDetailViewController alloc]init];
    vc.user_id = headerinfoDic[@"id"];
    [self transformView:vc];
}

-(void)logoutClick{
    NSLog(@"----退出登录");
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_ID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_KEY"];
    self.tabBarController.selectedIndex = 0;
}

#pragma mark- UITabelViewDeletage

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 6;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * cellID = @"tableviewCellID";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:headview];
        return cell;
    }else if (indexPath.section == 3){
        static NSString * cellID = @"tableviewCellID";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell addSubview:bottomview];
        return cell;
    } else {
        static NSString *CellIdentifier = @"XHHMeTableViewCell" ;
        XHHMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.titleImg.image = [UIImage imageNamed:@"bankCard"];
                cell.titleLab.text = @"我的银行卡";
            }else if (indexPath.row == 1){
                cell.titleImg.image = [UIImage imageNamed:@"ivtFriend"];
                cell.titleLab.text = @"邀请好友";
            }else if (indexPath.row == 2){
                cell.titleImg.image = [UIImage imageNamed:@"myTeanm"];
                cell.titleLab.text = @"我的团队";
            }else if (indexPath.row == 3){
                cell.titleImg.image = [UIImage imageNamed:@"Customer-"];
                cell.titleLab.text = @"我的专属客服";
            }else if (indexPath.row == 4){
                cell.titleImg.image = [UIImage imageNamed:@"letter"];
                cell.titleLab.text = @"站内信";
                
                if (![Messagenum isKindOfClass:[NSNull class]] && Messagenum != nil && Messagenum.length>0 && ![Messagenum isEqualToString:@"0"]) {
                    messageLab.hidden = NO;
                    NSString *str =[NSString stringWithFormat:@"%@条未读 ●",Messagenum];
                    NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
                    NSRange rangel = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(5, 1)]];
                    [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:rangel];
                    [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:rangel];
                    messageLab.font = [UIFont systemFontOfSize:12];
                    [messageLab setAttributedText:textColor];
                    [cell.contentView addSubview:messageLab];
                    [messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(20);
                        make.top.mas_equalTo(cell.contentView).offset(12);
                        make.bottom.mas_equalTo(cell.contentView).offset(-12);
                        make.right.mas_equalTo(cell.contentView).offset(-20);
                    }];
                }else{
                    messageLab.hidden = YES;
                    [self.tabBarController hideBadgeOnItemIndex:4];
                }
            }else{
                cell.titleImg.image = [UIImage imageNamed:@"hisOrder"];
                cell.titleLab.text = @"我的历史订单";
            }
            
        }else{
            if (indexPath.row == 0) {
                cell.titleImg.image = [UIImage imageNamed:@"telphone"];
                cell.titleLab.text = @"联系我们";
            }else if (indexPath.row == 1){
                cell.titleImg.image = [UIImage imageNamed:@"about"];
                cell.titleLab.text = @"关于鑫汇行";
            }else{
                cell.titleImg.image = [UIImage imageNamed:@"feedback"];
                cell.titleLab.text = @"帮助中心";
            }
        
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            XHHMyCardViewController *vc = [[XHHMyCardViewController alloc]init];
            vc.user_id = headerinfoDic[@"id"];
            [self transformView:vc];
        }else if (indexPath.row == 1){
            XHHInvitefriViewController *vc = [[XHHInvitefriViewController alloc] init];
            vc.user_id = headerinfoDic[@"id"];
            [self transformView:vc];
        }else if (indexPath.row == 2){
//            NSDictionary *dic = @{@"title":@"团队长：张三",@"tel":@"12345678900",@"qq":@"1065957388"};
            NSString *str = @"1";
            [self kefu:str];
        }else if (indexPath.row == 3){
//            NSLog(@"----点击了专属客服");
//            NSDictionary *dic = @{@"title":@"客服：张三",@"tel":@"0512-68888888",@"qq":@"1065957388"};
            NSString *str = @"2";
            [self kefu:str];
        }else if (indexPath.row == 4){
            NSLog(@"----点击了站内信");
            XHHMessageViewController *vc = [[XHHMessageViewController alloc]init];
            vc.user_id = headerinfoDic[@"id"];
            [self transformView:vc];
        }else {
            XHHMyHistoryOrderViewController *vc = [[XHHMyHistoryOrderViewController alloc] init];
            [self transformView:vc];
        }
    }else if (indexPath.section == 2){
    
        if (indexPath.row == 0) {
            XHHConnctUsViewController *vc = [[XHHConnctUsViewController alloc] init];
            [self transformView:vc];
        }else if (indexPath.row == 1){
            XHHAboutUsViewController *vc = [[XHHAboutUsViewController alloc] init];
            [self transformView:vc];
        }else {
            NSLog(@"----点击了帮助与反馈");
            XHHHelpViewController *vc = [[XHHHelpViewController alloc] init];
            [self transformView:vc];
        }
    }

}

-(void)kefu:(NSString*)str{
//    NSString *title = dic[@"title"];
//    NSString *tel = dic[@"tel"];
//    NSString *qq = dic[@"qq"];
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1018);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); //user.integerValue
    params[@"user_id"] = @(user_id.integerValue);
    if ([str isEqualToString:@"1"]) {
        params[@"do"] = @(1);
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1018&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----kefu=%@",responseObject);
        if ([responseObject [@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                NSDictionary *dic = responseObject[@"list"];
                NSString *namestr = dic[@"admin_name"];
                NSString *tel = dic[@"phone"];
                NSString *qq = dic[@"qq"];
                NSString *title = nil;
                if ([str isEqualToString:@"1"]) {
                    title = [NSString stringWithFormat:@"团队长：%@",namestr];
                }else{
                    title = [NSString stringWithFormat:@"客服：%@",namestr];
                }
                
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
    if (indexPath.section == 0) {
        return 170;
    }else if (indexPath.section == 3){
        return 85;
    } else {
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 15;
    }else if(section == 2){
        return 15;
    }else{
        return 15;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
