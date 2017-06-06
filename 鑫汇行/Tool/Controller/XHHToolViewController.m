//
//  XHHToolViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHToolViewController.h"
#import "XHHMeTableViewCell.h"
#import "Masonry.h"
#import "LhkhHttpsManager.h"
#import "XHHFanfeiViewController.h"
#import "XHHDaikuanViewController.h"
#import "XHHGongzhengchuViewController.h"
#import "XHHJianweiViewController.h"
#import "XHHZhengxindianViewController.h"
#import "MBProgressHUD+Add.h"
@interface XHHToolViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *fanfeiUrl;
    NSString *daikuanUrl;
    NSString *gongzhengchuUrl;
    NSString *jianweiUrl;
    NSString *zhengxindianUrl;
}
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation XHHToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工具";
    [self setTableView];
    [self loadData];
}

-(void)loadData{
   
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1009",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----order=%@",responseObject);
        fanfeiUrl = responseObject[@"list"][@"fanfei"];
        daikuanUrl = responseObject[@"list"][@"daikuan"];
        gongzhengchuUrl = responseObject[@"list"][@"gongzhengchu"];
        jianweiUrl = responseObject[@"list"][@"jianwei"];
        zhengxindianUrl = responseObject[@"list"][@"zhengxindian"];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHMeTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHMeTableViewCell"];
        tableView.backgroundColor = RGBA(236, 236, 236, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-54);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 3;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"XHHMeTableViewCell" ;
    XHHMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed :CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleImg.image = [UIImage imageNamed:@"fanCalculator"];
            cell.titleLab.text = @"返费计算器";
        }else {
            cell.titleImg.image = [UIImage imageNamed:@"daiCalculator"];
            cell.titleLab.text = @"贷款计算器";
        }
            
    }else{
            if (indexPath.row == 0) {
                cell.titleImg.image = [UIImage imageNamed:@"creditReport"];
                cell.titleLab.text = @"查公证处";
            }else if (indexPath.row == 1){
                cell.titleImg.image = [UIImage imageNamed:@"appoint"];
                cell.titleLab.text = @"查建委";
            }else{
                cell.titleImg.image = [UIImage imageNamed:@"reference"];
                cell.titleLab.text = @"查征信点";
            }
        }
        return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==1) {
        return 20;
    }
    return 15;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            XHHFanfeiViewController *vc = [[XHHFanfeiViewController alloc] init];
            vc.url = fanfeiUrl;
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            XHHDaikuanViewController *vc = [[XHHDaikuanViewController alloc] init];
            vc.url = daikuanUrl;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }else{
    
        if (indexPath.row == 0) {
            XHHGongzhengchuViewController *vc = [[XHHGongzhengchuViewController alloc] init];
            vc.url = gongzhengchuUrl;
            [self.navigationController pushViewController:vc animated:NO];
        }else if(indexPath.row == 1){
            XHHJianweiViewController *vc = [[XHHJianweiViewController alloc] init];
            vc.url = jianweiUrl;
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            XHHZhengxindianViewController *vc = [[XHHZhengxindianViewController alloc] init];
            vc.url = zhengxindianUrl;
            [self.navigationController pushViewController:vc animated:NO];
        }
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
