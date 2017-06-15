//
//  XHHProductViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHProductViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "Masonry.h"
#import "XHHProductTableViewCell.h"
#import "XHHSingleProViewController.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "XHHProductModel.h"
#import "UIImageView+WebCache.h"
@interface XHHProductViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *productList;
}
@property (nonatomic,strong)UITableView *tableView;
@end
static NSInteger page = 0;
@implementation XHHProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品";
    productList = [NSMutableArray array];
    [self setTableView];
    
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1004&page_num=0&list_rows=8",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----product=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        productList = [XHHProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        NSString *totalnum = responseObject[@"totalnum"];
        if ([totalnum isEqualToString:@"0"] ) {
            MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
            footer.stateLabel.text = @"没有更多了";
        }
        page = 0;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

-(void)loadMoreData{
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1004&page_num=%ld&list_rows=8",XHHBaseUrl,page];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----product=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
      
        [productList addObjectsFromArray:[XHHProductModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        NSString *totalnum = responseObject[@"totalnum"];
        if ([totalnum isEqualToString:@"0"] ) {
            MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.tableView.mj_footer;
            footer.stateLabel.text = @"没有更多了";
        }
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHProductTableViewCell"];
        
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
    self.tableView.mj_footer = [self loadMoreDataFooterWith:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
}

-(MJRefreshAutoNormalFooter *)loadMoreDataFooterWith:(UIScrollView *)scrollView {
    MJRefreshAutoNormalFooter *loadMoreFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self loadMoreData];
        [scrollView.mj_footer endRefreshing];
    }];
    
    return loadMoreFooter;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return productList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"XHHProductTableViewCell" ;
    XHHProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    XHHProductModel *model = productList[indexPath.row];
    cell.proName.text = model.pro_name;
    cell.prosmallText.text = model.pro_smalltxt;
    [cell.proImg sd_setImageWithURL:[NSURL URLWithString:model.pro_pic] placeholderImage:[UIImage imageNamed:@"default"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XHHProductModel *model = productList[indexPath.row];
    XHHSingleProViewController *vc = [[XHHSingleProViewController alloc]init];
    vc.pro_id = model.pro_id;
    vc.pro_name = model.pro_name;
    [self.navigationController pushViewController:vc animated:NO];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
