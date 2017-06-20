//
//  XHHHelpViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/22.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHHelpViewController.h"
#import "XHHHelpCenterTableViewCell.h"
#import "UIColor+LhkhColor.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
@interface XHHHelpViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isOpen;
    NSInteger openIndex;
    NSMutableArray *helpArr;
    float Hight;
}
@property(nonatomic,strong)UITableView *tableView;

@end
static float height;
@implementation XHHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帮助中心";
    self.view.backgroundColor = [UIColor colorWithHexString:UIBgColorStr];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    helpArr = [NSMutableArray array];
    [self setTableView];
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1013",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----product=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        helpArr = responseObject[@"list"];
        [self.tableView reloadData];
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
        [tableView registerNib:[UINib nibWithNibName:@"XHHHelpCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHHelpCenterTableViewCell"];
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
    return helpArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"XHHHelpCenterTableViewCell" ;
    XHHHelpCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    NSDictionary *dic = helpArr[indexPath.row];
    cell.qusLab.text = dic[@"title"];
    cell.answerLab.text = dic[@"content"];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize theSize = [cell.answerLab.text boundingRectWithSize:CGSizeMake(ScreenWidth, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    
    height = theSize.height;
    NSLog(@"%f",height);
    
    cell.opencellBlock = ^(){
        openIndex = indexPath.row;
        isOpen = !isOpen;
        if (isOpen == YES) {
            Hight = height + 100;
            cell.jiantouImg.image = [UIImage imageNamed:@"arrow_up_up"];
        }else{
            cell.jiantouImg.image = [UIImage imageNamed:@"arrow_down_down"];
        }
        [self.tableView reloadData];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isOpen == YES) {
        if (indexPath.row == openIndex) {
            return Hight;
        }
    }
    return 60;
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
