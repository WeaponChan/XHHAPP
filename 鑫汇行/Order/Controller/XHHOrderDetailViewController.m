//
//  XHHOrderDetailViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/17.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHOrderDetailViewController.h"
#import "Masonry.h"
#import "XHHOrderDetailFirTableViewCell.h"
#import "XHHOrderDetailSecTableViewCell.h"
#import "XHHOrderDetailCollectionViewCell.h"
#import "XHHSingleProApplyImgTableViewCell.h"
#import "LhkhHttpsManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "XHHOrderDetailModel.h"
#import "XHHInspectImage.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
@interface XHHOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) XHHOrderDetailModel *orderDetailModel;
@property (nonatomic,strong)NSArray *userPicsArr;
@end

@implementation XHHOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.userPicsArr = [NSArray array];
    [self setTableView];
}
-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHOrderDetailFirTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHOrderDetailFirTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"XHHOrderDetailSecTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHOrderDetailSecTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"XHHSingleProApplyImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHSingleProApplyImgTableViewCell"];
        
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
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(0);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1008);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue);
    params[@"id"] = @(_ID.integerValue);
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1008&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    NSLog(@"----params=%@",params);
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----orderDetail=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = [responseObject objectForKey:@"list"];
                NSDictionary *detail = data[@"order_info"];
                self.orderDetailModel = [XHHOrderDetailModel mj_objectWithKeyValues:detail];
                self.userPicsArr = responseObject[@"list"][@"user_pics"];
            }
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
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 7;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"XHHOrderDetailFirTableViewCell" ;
        XHHOrderDetailFirTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.orderNumLab.text = [NSString stringWithFormat:@"订单编号: %@",self.orderID];
        if ([self.status isEqualToString:@"3"] || [self.status isEqualToString:@"4"]) {
            cell.orderStatus.text = @"已放款";
        }else if ([self.status isEqualToString:@"1"] || [self.status isEqualToString:@"2"]){
            cell.orderStatus.text = @"申请中";
        }else{
            cell.orderStatus.text = @"未通过";
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"XHHOrderDetailSecTableViewCell" ;
        XHHOrderDetailSecTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            cell.titleLab.text = @"姓名";
            cell.infoLab.text = self.orderDetailModel.user_name;
        }else if (indexPath.row == 1){
            cell.titleLab.text = @"身份证号";
            cell.infoLab.text = self.orderDetailModel.icard;
        }else if (indexPath.row == 2){
            cell.titleLab.text = @"手机号";
            cell.infoLab.text = self.orderDetailModel.phone;
        }else if (indexPath.row == 3){
            cell.titleLab.text = @"产品名称";
            cell.infoLab.text = self.orderDetailModel.pro_name;
        }else if (indexPath.row == 4){
            cell.titleLab.text = @"申请金额";
            cell.infoLab.text = [NSString stringWithFormat:@"￥%@",self.orderDetailModel.order_money];
        }else if (indexPath.row == 5){
            if ([self.orderDetailModel.status isEqualToString:@"5"]) {
                cell.titleLab.text = @"未通过原因";
                cell.infoLab.text = self.orderDetailModel.refuse_reason;
            }else{
                cell.titleLab.text = @"审批金额";
                cell.infoLab.text = [NSString stringWithFormat:@"￥%@",self.orderDetailModel.sure_money];
            }
            
        }else{
            cell.titleLab.text = @"下单时间";
            cell.infoLab.text = self.orderDetailModel.addtime;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"XHHSingleProApplyImgTableViewCell" ;
        XHHSingleProApplyImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.applyImgCollectionView registerNib:[UINib  nibWithNibName:@"XHHOrderDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XHHOrderDetailCollectionViewCell"];
        cell.applyImgCollectionView.delegate = self;
        cell.applyImgCollectionView.dataSource = self;
        [cell.applyImgCollectionView reloadData];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return ((self.userPicsArr.count +1)/2)*((ScreenWidth-90)/2.4) +((self.userPicsArr.count+1)/2)*35;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 15;
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userPicsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHHOrderDetailCollectionViewCell *cell = (XHHOrderDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XHHOrderDetailCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.userPicsArr[indexPath.row];
    [cell.orderDetailImg sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"default"]];
    cell.imgLab.text = dic[@"name"];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----->%ld",indexPath.row);
//    XHHOrderDetailCollectionViewCell *cell = (XHHOrderDetailCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XHHOrderDetailCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = self.userPicsArr[indexPath.row];
    UIImageView *image = [[UIImageView alloc] init];
    [image sd_setImageWithURL:[NSURL URLWithString:dic[@"pic"]] placeholderImage:[UIImage imageNamed:@"default"]];
    [XHHInspectImage showImage:image];
}
#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = ((ScreenWidth-90)/2);
    return CGSizeMake(width, width/1.2f);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(20, 30, 20, 30);
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
