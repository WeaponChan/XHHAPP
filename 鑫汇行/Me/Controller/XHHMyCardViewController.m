//
//  XHHMyCardViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMyCardViewController.h"
#import "UIColor+LhkhColor.h"
#import "XHHAddCardViewController.h"
#import "Masonry.h"
#import "XHHSingleProApplyTableViewCell.h"
#import "XHHxiugaiTableViewCell.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
@interface XHHMyCardViewController ()<UITableViewDelegate,UITableViewDataSource,returnValueDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UIView *headView;
    UIView *view1;
    UIView *view2;
    NSString *bankStr;
    NSString *bank_id;
    UITextField *text1;
    UITextField *text2;
    
    UIView *bankview;
    NSMutableArray *bankArr;
    UIControl *_blackView;
//    UIView *proView;
    
    UITextField *userName;
    UITextField *IDcard;
    UITextField *bankcard;
    UITextField *bankName;
    UITextField *province;
    UITextField *bankbranch;
    NSString *cardid;
    UIButton *btn;
    BOOL isModify;
    BOOL isModifySuc;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITableView *banktableView;
@property (nonatomic,strong)UIView *pickerRootView;
@property (nonatomic,strong)UIPickerView *pickerView;
@end

@implementation XHHMyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的银行卡";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    self.blankView.layer.cornerRadius = 4.f;
    self.blankView.layer.masksToBounds = YES;
    [self setheadView];
    [self setproView];
    [self setTableView];
    [self setblackView];
    [self setTextview];
    [self loadData];
    self.blankView.hidden = YES;
    headView.hidden = YES;
    self.tableView.hidden = YES;
    [self showLoadingView];
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1019);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); //user.integerValue
    params[@"user_id"] = @(user_id.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1019&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----bankcard=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                [self closeLoadingView];
                self.blankView.hidden = YES;
                headView.hidden = NO;
                self.tableView.hidden = NO;
                
                NSDictionary *dic = responseObject[@"list"];
                IDcard.text = dic[@"icard"];
                userName.text = dic[@"name"];
                bankcard.text = dic[@"bankcard"];
                bankbranch.text = dic[@"bank_branch"];
                bankName.text = dic[@"bank_name"];
                province.text = [NSString stringWithFormat:@"%@%@",dic[@"province"],dic[@"city"]];
                text1.text = dic[@"province"];
                text2.text = dic[@"city"];
                cardid = dic[@"id"];
                userName.enabled = NO;
                IDcard.enabled = NO;
                bankcard.enabled = NO;
                bankbranch.enabled = NO;
                bankName.enabled = NO;
                province.enabled = NO;
            }else{
                [self closeLoadingView];
                self.blankView.hidden = NO;
                headView.hidden = YES;
                self.tableView.hidden = YES;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            [self closeLoadingView];
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
            
        }else{
            [self closeLoadingView];
            self.blankView.hidden = NO;
            headView.hidden = YES;
            self.tableView.hidden = YES;
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        
    } failure:^(NSError *error) {
        [self closeLoadingView];
        self.blankView.hidden = NO;
        headView.hidden = YES;
        self.tableView.hidden = YES;
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];

}

-(void)login{
    [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
}

-(void)setblackView{
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -  180)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    
}

-(void)setTextview{
    userName = [[UITextField alloc] initWithFrame:CGRectZero];
    IDcard = [[UITextField alloc] initWithFrame:CGRectZero];
    bankcard = [[UITextField alloc] initWithFrame:CGRectZero];
    bankName = [[UITextField alloc] initWithFrame:CGRectZero];
    province = [[UITextField alloc] initWithFrame:CGRectZero];
    bankbranch = [[UITextField alloc] initWithFrame:CGRectZero];

}

-(void)returnValue:(NSString *)value{
    if ([value isEqualToString:@"1"]) {
        self.blankView.hidden = YES;
        headView.hidden = NO;
        self.tableView.hidden = NO;
        [self loadData];
    }
}
-(void)setheadView{
    headView = [[UIView alloc]initWithFrame:CGRectZero];
    headView.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    lab.text = @"为保证返费安全，请你在修改时如实填写以下信息，鑫汇行承诺恪守用户信息(建议绑定本人银行卡)";
    lab.textColor = [UIColor grayColor];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:12];
    [headView addSubview:lab];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50);
        make.left.right.top.mas_equalTo(self.view).offset(0);
        
    }];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView).offset(5);
        make.bottom.mas_equalTo(headView).offset(-5);
        make.left.mas_equalTo(headView).offset(15);
        make.right.mas_equalTo(headView).offset(-15);
    }];
    
}

-(void)setproView{
    
    view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.layer.cornerRadius = 4.f;
    view1.layer.masksToBounds = YES;
    view1.layer.borderColor = [UIColor grayColor].CGColor;
    view1.layer.borderWidth = 1.f;
    btn = [[UIButton alloc] initWithFrame:CGRectZero];
    [btn addTarget:self action:@selector(openBank) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:btn];
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    lab1.text = @"▲";
    lab1.textColor = [UIColor grayColor];
    lab1.font = [UIFont systemFontOfSize:12];
    [view1 addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    lab2.text = @"▼";
    lab2.textColor = [UIColor grayColor];
    lab2.font = [UIFont systemFontOfSize:12];
    [view1 addSubview:lab2];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.mas_equalTo(view1).offset(0);
    }];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view1).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(view1).offset(4);
    }];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view1).offset(-10);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(view1).offset(-4);
    }];
    
    view2 = [[UIView alloc] initWithFrame:CGRectZero];
    text1 = [[UITextField alloc] initWithFrame:CGRectZero];
    text1.placeholder = @"请输入省";
    text1.font = [UIFont systemFontOfSize:14];
    [view2 addSubview:text1];
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    lab3.text = @"省";
    lab3.font = [UIFont systemFontOfSize:14];
    [view2 addSubview:lab3];
    text2 = [[UITextField alloc] initWithFrame:CGRectZero];
    text2.placeholder = @"请输入市";
    text2.font = [UIFont systemFontOfSize:14];
    [view2 addSubview:text2];
    UILabel *lab4 = [[UILabel alloc] initWithFrame:CGRectZero];
    lab4.text = @"市";
    lab4.font = [UIFont systemFontOfSize:14];
    [view2 addSubview:lab4];
    
    [text1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view2).offset(10);
        make.centerY.mas_equalTo(view2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(text1.mas_right).offset(5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(text1);
    }];
    [text2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lab3.mas_right).offset(10);
        make.centerY.mas_equalTo(view2);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(text2.mas_right).offset(5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        make.centerY.mas_equalTo(text2);
    }];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHSingleProApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHSingleProApplyTableViewCell"];
        
        [tableView registerNib:[UINib nibWithNibName:@"XHHxiugaiTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHxiugaiTableViewCell"];
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    [self.tableView.mj_header beginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(headView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}
- (IBAction)addCardClick:(id)sender {
    XHHAddCardViewController *vc = [[XHHAddCardViewController alloc]init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    vc.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:vc animated:NO];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.banktableView) {
        return bankArr.count;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.banktableView) {
        return 1;
    }else{
        if (section == 0) {
            return 6;
        }else {
            return 1;
        }
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.banktableView) {
        static NSString *cellId = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.contentView.backgroundColor = RGBA(217, 217, 217, 1);
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 29, cell.frame.size.width, 1)];
        view.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:view];
        cell.textLabel.text = bankArr[indexPath.section];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
        
    }else{
        __weak typeof(self)weakself = self;
        static NSString *CellIdentifier = @"XHHSingleProApplyTableViewCell" ;
        XHHSingleProApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
   
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.nameLab.text = @"持卡人";
                userName.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:userName];
                [userName mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
            }else if (indexPath.row == 1){
                cell.nameLab.text = @"身份证";
                IDcard.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:IDcard];
                [IDcard mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
            }else if(indexPath.row == 2){
                cell.nameLab.text = @"银行卡号";
                bankcard.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:bankcard];
                [bankcard mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
            }else if (indexPath.row == 3){
                bankName.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:bankName];
                [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
                cell.nameLab.text = @"开户银行";
                if (isModify == NO) {
                    view1.hidden = YES;
                    
                }else{
                    view1.hidden = NO;
                    if (bankStr == nil) {

                    }else{
                        bankName.text = [NSString stringWithFormat:@" %@",bankStr];
                    }
                    [cell.contentView addSubview:view1];
                    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                        make.top.mas_equalTo(cell).offset(5);
                        make.bottom.mas_equalTo(cell).offset(-5);
                        make.right.mas_equalTo(cell).offset(-20);
                    }];
                    
                }
                
            }else if (indexPath.row == 4){
                cell.nameLab.text = @"开户省市";
                province.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:province];
                [province mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
                if (isModify == YES) {
                    province.hidden = YES;
                    view2.hidden = NO;
                    [cell.contentView addSubview:view2];
                    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.nameLab.mas_right).offset(0);
                        make.top.mas_equalTo(cell).offset(5);
                        make.bottom.mas_equalTo(cell).offset(-5);
                        make.right.mas_equalTo(cell).offset(-20);
                    }];
                    
                }else{
                    view2.hidden = YES;
                    province.hidden = NO;
                }
            }else{
                cell.nameLab.text = @"开户支行";
                bankbranch.font = [UIFont systemFontOfSize:14];
                [cell.contentView addSubview:bankbranch];
                [bankbranch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                    make.centerY.mas_equalTo(cell.nameLab);
                    make.height.mas_equalTo(30);
                    make.right.mas_equalTo(cell).mas_equalTo(-10);
                }];
            }
        }
        if (indexPath.section == 1) {
            static NSString *CellIdentifier = @"XHHxiugaiTableViewCell" ;
            XHHxiugaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
                cell = [array objectAtIndex:0];
            }
            cell.xiugaiblock = ^(){
                NSLog(@"----点击了修改");
                if (isModifySuc == NO) {
                    
                }
                isModify = !isModify;
                if (isModify == NO) {
                    self.navigationItem.title = @"我的银行卡";
                    [cell.xiugaiBtn setTitle:@"修改" forState:UIControlStateNormal];
                    [self modifybankcard];
                
                }else{
                    userName.enabled = YES;
                    IDcard.enabled = YES;
                    bankcard.enabled = YES;
                    bankbranch.enabled = YES;
                    bankName.enabled = YES;
                    province.enabled = YES;
                    self.navigationItem.title = @"修改银行卡";
                    [cell.xiugaiBtn setTitle:@"保存" forState:UIControlStateNormal];
                }
                
                [self.tableView reloadData];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.banktableView) {
        return 30;
    }
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.banktableView) {
        return 0;
    }else{
        if (section == 1) {
            return 40;
        }
        return 0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.banktableView) {
        bankStr = bankArr[indexPath.section];
        bankview.hidden = YES;
        [self.tableView reloadData];
    }
}

-(void)modifybankcard{
    NSString *regex = @"[a-zA-Z. ]*";
    NSPredicate *Engpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *Zhpredicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    NSString *num = @"[0-9]";
    NSPredicate *Numgpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    NSString *namestr = userName.text;
    if (userName.text == nil || [userName.text isEqualToString:@""]) {
        [MBProgressHUD show:@"姓名不能为空" view:self.view];
        return;
    }
    if (userName.text.length < 2 || userName.text.length >30) {
        [MBProgressHUD show:@"姓名长度不能低于2且不能大于30，请重新修改" view:self.view];
        return;
    }
    if ([Engpredicate evaluateWithObject:namestr] == NO && [Zhpredicate evaluateWithObject:namestr] == NO) {
        [MBProgressHUD show:@"姓名只能是全英文或者全汉字,请修改!" view:self.view];
        return;
    }
    if (IDcard.text == nil || [IDcard.text isEqualToString:@""]) {
        [MBProgressHUD show:@"身份证号码不能为空" view:self.view];
        return;
    }
    
    if ([self judgeIdentityStringValid:IDcard.text] == NO) {
        [MBProgressHUD show:@"身份证号码格式不对" view:self.view];
        return;
    }
    
    if (userName.text == nil || [userName.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请正确填写您的真实姓名" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }
    if (IDcard.text == nil || [IDcard.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请正确填写您的身份证号" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }
    if (bankcard.text == nil || [bankcard.text isEqualToString:@""] || [Numgpredicate evaluateWithObject:namestr] == YES) {
        [MBProgressHUD show:@"请正确填写您的银行卡号" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }
    if (bankName.text == nil || [bankName.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请正确选择您的开户银行" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }
    if (text1.text == nil || text2.text == nil || [text1.text isEqualToString:@""] || [text2.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请正确填写您的开户省市" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }
    if (bankbranch.text == nil || [bankbranch.text isEqualToString:@""]) {
        [MBProgressHUD show:@"请正确填写您的开户支行" view:self.view];
        isModifySuc = NO;
        isModify = NO;
        return;
    }

    [self showLoadingView];
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1019);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); 
    params[@"user_id"] = @(user_id.integerValue);
    
    params[@"name"] = userName.text;
    params[@"icard"] = IDcard.text;
    params[@"bankcard"] = @(bankcard.text.integerValue);
    params[@"bank_id"] = @(bank_id.integerValue);
    params[@"province"] = [NSString stringWithFormat:@"%@",text1.text];
    params[@"city"] = [NSString stringWithFormat:@"%@",text2.text];
    params[@"bank_branch"] = bankbranch.text;
    params[@"do"] = @(3);
    params[@"card_id"] = @(cardid.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1019&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:2 success:^(id responseObject) {
        NSLog(@"-----modifybankcard=%@",responseObject);
        if (responseObject[@"list"] && [responseObject[@"status"] isEqualToString:@"1"]) {
            [self closeLoadingView];
            userName.enabled = NO;
            IDcard.enabled = NO;
            bankcard.enabled = NO;
            bankbranch.enabled = NO;
            bankName.enabled = NO;
            province.enabled = NO;
            isModifySuc = YES;
            [self loadData];
            [MBProgressHUD show:@"修改成功" view:self.view];
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            [self closeLoadingView];
            userName.enabled = YES;
            IDcard.enabled = YES;
            bankcard.enabled = YES;
            bankbranch.enabled = YES;
            bankName.enabled = NO;
            province.enabled = YES;
            isModifySuc = NO;
            isModify = NO;
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
        }else{
            [self closeLoadingView];
            userName.enabled = YES;
            IDcard.enabled = YES;
            bankcard.enabled = YES;
            bankbranch.enabled = YES;
            bankName.enabled = NO;
            province.enabled = YES;
            isModifySuc = NO;
            isModify = NO;
            [MBProgressHUD show:@"修改失败" view:self.view];
        }
        
    } failure:^(NSError *error) {
        isModifySuc = NO;
        isModify = NO;
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
        [self closeLoadingView];
    }];
}

-(void)openBank{
    NSLog(@"mmmmmm");
//    [self setBankView];
    btn.enabled = NO;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1020",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----bank=%@",responseObject);
        bankArr = [NSMutableArray array];
        NSArray *arr = responseObject[@"list"];
        [bankArr addObjectsFromArray:arr];
        [self setPickerView];
        btn.enabled = YES;
    } failure:^(NSError *error) {
        [self closeLoadingView];
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}


-(void)setBankView{
    
//    NSArray *arr = @[@"中国银行",@"中国农业银行",@"中国建设银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行"];
    
    bankview = [[UIView alloc] initWithFrame:CGRectMake(view1.frame.origin.x, 210, view1.frame.size.width, 120)];
    [self.view addSubview:bankview];
    
    [self setBankTableView];
}

-(void)setBankTableView{
    _banktableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [bankview addSubview:tableView];
        tableView;
    });
    [self.banktableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(bankview);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isHaveCard == YES) {
        self.blankView.hidden = YES;
        headView.hidden = NO;
        self.tableView.hidden = NO;
        [self setheadView];
        [self setTableView];
    }else{
        self.blankView.hidden = NO;
        headView.hidden = YES;
        self.tableView.hidden = YES;
    }
    
}

-(void)setPickerView{
//    bankArr = [NSMutableArray array];
//    NSArray *arr = @[@"中国银行",@"中国农业银行",@"中国建设银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行",@"中国交通银行"];
//    [bankArr addObjectsFromArray:arr];
    _pickerRootView = [[UIView alloc] initWithFrame:CGRectZero];
    _pickerRootView.hidden = _blackView.hidden = NO;
    [self.view addSubview:_pickerRootView];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    cancelBtn.layer.cornerRadius = 4.f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.backgroundColor = [UIColor colorWithHexString:UIColorStr];
    [cancelBtn addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    sureBtn.layer.cornerRadius = 4.f;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor colorWithHexString:UIColorStr];
    [sureBtn addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_pickerRootView addSubview:cancelBtn];
    [_pickerRootView addSubview:sureBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_pickerRootView).offset(15);
        make.top.mas_equalTo(_pickerRootView).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_pickerRootView).offset(-15);
        make.top.mas_equalTo(_pickerRootView).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_pickerRootView addSubview:_pickerView];
    [_pickerRootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(180);
    }];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_pickerRootView).offset(0);
        make.height.mas_equalTo(136);
    }];
}

-(void)cancelButtonAction:(id)sender{
    
    _blackView.hidden = _pickerRootView.hidden = YES;
}

-(void)sureButtonAction:(id)sender{
    if ([bankStr isEqualToString:@""] || [bank_id isEqualToString:@""] || bankStr == nil || bank_id == nil) {
        bankStr = bankArr[0][@"name"];
        bank_id = bankArr[0][@"bank_id"];
    }
    _blackView.hidden =  _pickerRootView.hidden = YES;
    [self.tableView reloadData];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return bankArr.count;
}

#pragma mark - delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",bankArr[row][@"name"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    bankStr = bankArr[row][@"name"];
    bank_id = bankArr[row][@"bank_id"];
}

#pragma mark 判断身份证号是否合法
- (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    NSLog(@"identityString===%@",identityString);
    
    if ([identityString length] < 15 ||[identityString length] > 18) {
        return NO;
    }
    
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:identityString];
    if ([identityString length] == 15) {
        
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        identityString = mString;
        
    }
    
    
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex  = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum      += subStrIndex * idCardWiIndex;
    }
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
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
