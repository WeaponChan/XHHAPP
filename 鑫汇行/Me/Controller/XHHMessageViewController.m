//
//  XHHMessageViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/22.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMessageViewController.h"
#import "UIColor+LhkhColor.h"
#import "XHHMessageTableViewCell.h"
#import "Masonry.h"
#import "XHHMessageDetailViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
@interface XHHMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *messageArr;
@end

@implementation XHHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"站内信";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    [self setTableView];
    _messageArr = [NSMutableArray array];
}

-(void)loadData{

    NSLog(@"user_id----->%@",_user_id);
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"User"];
    params[@"action"] = @(1015);
    params[@"user_id"] = @(_user_id.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1015",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----message=%@",responseObject);
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *arr = responseObject[@"list"];
            [_messageArr removeAllObjects];
            [_messageArr addObjectsFromArray:arr];
        }
        
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHMessageTableViewCell"];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"XHHMessageTableViewCell" ;
    XHHMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    NSDictionary *dic = _messageArr[indexPath.row];
    cell.messageTitleLab.text = dic[@"title"];
    cell.timeLab.text = dic[@"addtime"];
    cell.messageLab.text = dic[@"content"];
    NSString *status = dic[@"status"];
    if ([status isEqualToString:@"0"]) {
        cell.statusLab.hidden = YES;
    }else{
        cell.statusLab.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XHHMessageDetailViewController *vc = [[XHHMessageDetailViewController alloc] init];
    NSDictionary *dic = _messageArr[indexPath.row];
    vc.user_id = _user_id;
    vc.message_id = dic[@"id"];
    vc.message_status = dic[@"status"];
    [self.navigationController pushViewController:vc animated:NO];
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
