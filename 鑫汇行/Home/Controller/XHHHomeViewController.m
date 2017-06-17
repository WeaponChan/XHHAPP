//
//  XHHHomeViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHHomeViewController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "XHHMidView.h"
#import "XHHMidViewModel.h"
#import "XHHHomeAdTableViewCell.h"
#import "CCPScrollView.h"
#import "LhkhHttpsManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "XHHHomeProModel.h"
#import "XHHBottomViewModel.h"
#import "XHHBottomView.h"
#import "XHHPageControl.h"
@interface XHHHomeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UIView *headview;
    UIView *midview;
    UIView *bottomview;
    UIButton *leftBtn;
    UIButton *rightBtn;
    CGFloat adWidth;
    CGFloat adHeight;
    NSMutableArray *homeProArr;
    NSString *news_title;
    NSMutableArray *temptitleArr;
    NSMutableArray *tempArr;
    NSMutableArray *titlearr;
    CCPScrollView *ccpView;
    float height;
}
@property (nonatomic,strong)UITableView *tableView;
@property (strong,nonatomic)UIScrollView *imageScrollView;
@property (strong,nonatomic)UIScrollView *midViewScrollView;
@property (strong,nonatomic)XHHPageControl *pagecontrol;
@property (strong,nonatomic)XHHPageControl *midviewpagecontrol;
@property (strong,nonatomic)NSTimer *timer;
@property (strong,nonatomic)NSMutableArray *imageArray;
@property (strong,nonatomic)NSMutableArray *viewArray;
@end
static int proPage = 0;
@implementation XHHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    homeProArr = [NSMutableArray array];
    [self setTableView];
    [self buildheadView];
    [self buildmidView];
    [self buildbottomView];
    
}
-(void)loadData{
   
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1003",XHHBaseUrl];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        
        NSLog(@"-----homeresponseObject=%@",responseObject);
        [self.tableView.mj_header endRefreshing];
        news_title = responseObject[@"list"][@"rebate_title"];
        _imageArray = responseObject[@"list"][@"banner"];
        if (_imageArray.count >0) {
            if (![_imageArray isKindOfClass:[NSNull class]] && _imageArray.count>0) {//防崩溃
                [self imageUIInit:_imageScrollView];
                [self addTimer];
            }
        }else{
            
            NSArray *imaArr = @[@"banner1.png",@"banner2.png"];
            _imageArray = [NSMutableArray array];
            [_imageArray addObjectsFromArray:imaArr];
            
            if (![_imageArray isKindOfClass:[NSNull class]] && _imageArray.count>0) {//防崩溃
                [self imageUIInit:_imageScrollView];
                [self addTimer];
            }
        }
       
        homeProArr = [XHHHomeProModel mj_objectArrayWithKeyValuesArray:responseObject[@"list"][@"product"]];
        if (![homeProArr isKindOfClass:[NSNull class]] && homeProArr.count>0) {
            [self imageUIInit:_midViewScrollView];
        }
        titlearr = [NSMutableArray array];
        tempArr = [NSMutableArray array];
        
        [titlearr removeAllObjects];
        [tempArr removeAllObjects];
        [temptitleArr removeAllObjects];
        NSArray *rebateArr = responseObject[@"list"][@"rebate"];
      
        NSLog(@"----rebateArr.count=%ld",(unsigned long)rebateArr.count);
        int i = 0;
        for (int k=0; k<((rebateArr.count+4)/4); k++) {
            temptitleArr = [NSMutableArray array];
            for (int j = i ; j < rebateArr.count; j++) {
                i = j;
                if (temptitleArr.count == 4) {
                    break;
                }
                NSDictionary *dic = rebateArr[j];
                NSString *rebate = [NSString stringWithFormat:@"%@%@  赚到返费  %ld元",dic[@"city"],dic[@"phone"],[dic[@"rebate_money"] integerValue]];
                [temptitleArr addObject:rebate];
            }
            [titlearr addObject:temptitleArr];
        }
        ccpView.titleArray = titlearr;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"-----homeerror=%@",[NSString stringWithFormat:@"%@",error]);
    }];

}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHHomeAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHHomeAdTableViewCell"];
//        tableView.backgroundColor = RGBA(236, 236, 236, 1);
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
    
    headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    _imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    _pagecontrol = [[XHHPageControl alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 160, 100, 20)];
    _pagecontrol.userInteractionEnabled = NO;
    [headview addSubview:_imageScrollView];
    [headview addSubview: _pagecontrol];
    
}

-(void)buildmidView{
    midview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
//    midview.backgroundColor = RGBA(236, 236, 236, 1);
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectZero];
    leftView.backgroundColor = RGBA(177, 177, 177, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectZero];
    rightView.backgroundColor = RGBA(177, 177, 177, 1);
    leftBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    leftBtn.hidden = YES;
    [leftBtn setImage:[UIImage imageNamed:@"Left_Arrow"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftViewClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn= [[UIButton alloc]initWithFrame:CGRectZero];
    rightBtn.hidden = YES;
    [rightBtn setImage:[UIImage imageNamed:@"xiayiye_arrow"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightViewClick) forControlEvents:UIControlEventTouchUpInside];
    [midview addSubview:leftView];
    [midview addSubview:label];
    [midview addSubview:rightView];
    
    label.text = @"推荐产品";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = RGBA(103, 103, 103, 1);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (midview).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.centerX.mas_equalTo(midview);
    }];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (midview).offset(20);
        make.right.mas_equalTo (label.mas_left).offset(-15);
        make.centerY.mas_equalTo(label);
        make.height.mas_equalTo(1);
        
    }];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (label.mas_right).offset(15);
        make.right.mas_equalTo (midview).offset(-20);
        make.centerY.mas_equalTo(label);
        make.height.mas_equalTo(1);
        
    }];
    
//    _midViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
//    _midviewpagecontrol = [[UIPageControl alloc]initWithFrame:CGRectZero];
    _midViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 55, ScreenWidth, 145)];
    _midviewpagecontrol = [[XHHPageControl alloc]initWithFrame:CGRectMake((ScreenWidth-100)/2, 180, 100, 20)];
    _midviewpagecontrol.userInteractionEnabled = NO;
    [midview addSubview:_midViewScrollView];
    [midview addSubview: _midviewpagecontrol];
    
    /*
    [_midViewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(15);
        make.left.right.mas_equalTo(midview).offset(0);
        make.height.mas_equalTo(130);        
    }];
    [_midviewpagecontrol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(midview).offset(0);
        make.left.right.mas_equalTo(midview).offset(0);
        make.height.mas_equalTo(20);
    }];
     */
    
    [midview addSubview:leftBtn];
    [midview addSubview:rightBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(midview);
        make.left.mas_equalTo(midview).offset(15);
    }];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.mas_equalTo(midview);
        make.right.mas_equalTo(midview).offset(-15);
    }];
}

-(void)buildbottomView{
    bottomview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
    ccpView = [[CCPScrollView alloc] initWithFrame:CGRectMake(0, 0, bottomview.frame.size.width, bottomview.frame.size.height)];
    ccpView.titleFont = 20;
    ccpView.tintColor = [UIColor redColor];
    [bottomview  addSubview:ccpView];
    
}

#pragma mark- UITabelViewDeletage

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"tableviewCellID";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        [cell addSubview:headview];
    }else if (indexPath.section == 1){
        [cell addSubview:midview];
    }else{
        static NSString *CellIdentifier = @"XHHHomeAdTableViewCell" ;
        XHHHomeAdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        NSString *str = nil;
        if (news_title == nil) {
            cell.titleLab.hidden = YES;
        }else{
            cell.titleLab.hidden = NO;
            cell.titleLab.text = [NSString  stringWithFormat:@"%@",news_title];
        }
        /*
        NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange rangel1 = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(0, 2)]];
        [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rangel1];
        [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rangel1];
        NSRange rangel2 = [[textColor string] rangeOfString:[str substringWithRange:NSMakeRange(str.length - 2, 2)]];
        [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rangel2];
        [textColor addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rangel2];
        
        [cell.titleLab setAttributedText:textColor];*/
        
        
        [cell.adView addSubview:bottomview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        return 200;
    }else{
        return 220;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        return 15;
    }else{
        return 15;
    }
}
#pragma mark- 图片相关
- (void)imageUIInit:(UIScrollView*)scrollView{
    if (scrollView == _imageScrollView) {
        CGFloat imageScrollViewWidth = ScreenWidth;
        CGFloat imageScrollViewHeight = _imageScrollView.bounds.size.height;
        
        for(int i = 0; i<_imageArray.count; i++) {
            if ([_imageArray[i] isKindOfClass:[NSNull class]]) {
                continue;
            }
        }
        for (int i=0; i<_imageArray.count; i++) {
            
            UIImageView *imageview =[[UIImageView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
            [imageview sd_setImageWithURL:[NSURL URLWithString:_imageArray[i][@"pic"]] placeholderImage:[UIImage imageNamed:@""]];
            
//             imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.tag = i;
            imageview.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
            [imageview addGestureRecognizer:singleTap];
            [_imageScrollView addSubview:imageview];
        }
        
        _imageScrollView.contentSize = CGSizeMake(imageScrollViewWidth*_imageArray.count, 0);
        _imageScrollView.bounces = NO;
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.delegate = self;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        
        _pagecontrol.numberOfPages = _imageArray.count;
        
        _pagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
        _pagecontrol.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        
    }else{
    
        CGFloat imageScrollViewWidth = midview.frame.size.width;
        CGFloat imageScrollViewHeight = _midViewScrollView.frame.size.height;
        
        for(int i = 0; i<homeProArr.count; i++) {
            if ([homeProArr[i] isKindOfClass:[NSNull class]]) {
                continue;
            }
        }

        for (int i=0; i<homeProArr.count; i++) {
           
            XHHMidView *view = [[XHHMidView alloc]initWithFrame:CGRectMake(imageScrollViewWidth*i, 0, imageScrollViewWidth,imageScrollViewHeight)];
            XHHHomeProModel *promodel = homeProArr[i];
            XHHMidViewModel *model = [XHHMidViewModel modelWithName:promodel.pro_rate title:promodel.pro_name info:promodel.pro_smalltxt];
            view.model = model;
            view.userInteractionEnabled = YES;
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
            CGSize theSize = [promodel.pro_smalltxt boundingRectWithSize:CGSizeMake(ScreenWidth, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesDeviceMetrics | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
            
            height = theSize.height;
//            NSLog(@"%f",height);
            
            [_midViewScrollView addSubview:view];
        }
        
        _midViewScrollView.contentSize = CGSizeMake(imageScrollViewWidth*homeProArr.count, 0);
        _midViewScrollView.bounces = NO;
        _midViewScrollView.pagingEnabled = YES;
        _midViewScrollView.delegate = self;
        _midViewScrollView.showsHorizontalScrollIndicator = NO;
        
        _midviewpagecontrol.numberOfPages = homeProArr.count;
        _midviewpagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
        _midviewpagecontrol.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    }
}

- (void)photoTapped:(UITapGestureRecognizer *)tap{
    NSLog(@"----点击了%ld",tap.view.tag);
}
/*
-(void)leftViewClick{
    int page = (int)_midviewpagecontrol.currentPage;
    if (page>0) {
        page--;
    }
    if (page == 0) {
        leftBtn.hidden = YES;
    }
    rightBtn.hidden = NO;
    CGFloat x = page * _midViewScrollView.frame.size.width;
    [_midViewScrollView  setContentOffset:CGPointMake(x, 0) animated:YES];
    _midviewpagecontrol.currentPage = page;
}
-(void)rightViewClick{
    int page = (int)_midviewpagecontrol.currentPage;
    if (page<2) {
        page++;
    }
    if (page==2) {
        rightBtn.hidden = YES;
    }
    leftBtn.hidden = NO;
    CGFloat x = page * _midViewScrollView.frame.size.width;
    [_midViewScrollView  setContentOffset:CGPointMake(x, 0) animated:YES];
    _midviewpagecontrol.currentPage = page;
}
*/
//开启定时器
- (void)addTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

//设置当前页 实现自动滚动
- (void)nextImage
{
    int page = (int)_pagecontrol.currentPage;
    
    if (page == _imageArray.count-1) {
        
        page = 0;
        
    }else{
        
        page++;
        
    }
    
    CGFloat x = page * _imageScrollView.frame.size.width;
    [_imageScrollView  setContentOffset:CGPointMake(x, 0) animated:NO];
    
}
//关闭定时器
- (void)removeTimer
{
    [self.timer invalidate];
}

#pragma mark ScrollView代理方法开始
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView == _imageScrollView) {
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        _pagecontrol.currentPage = page;
        
    }else if(scrollView == _midViewScrollView){
        CGFloat scrollviewW =  scrollView.frame.size.width;
        CGFloat x = scrollView.contentOffset.x;
        int page = (x + scrollviewW / 2) /  scrollviewW;
        _midviewpagecontrol.currentPage = page;
    }
 
}

-(void)rightimageAction{
    NSLog(@"right");
    int page = (int)_imageArray.count-1;
    CGFloat x = page * _imageScrollView.frame.size.width;
    [_imageScrollView  setContentOffset:CGPointMake(x, 0) animated:NO];
    _pagecontrol.currentPage = page;
}
-(void)leftimageAction{
    NSLog(@"left");
    int page = 0;
    CGFloat x = page * _imageScrollView.frame.size.width;
    [_imageScrollView  setContentOffset:CGPointMake(x, 0) animated:NO];
    _pagecontrol.currentPage = page;
}

-(void)rightmidViewAction{
    NSLog(@"right");
    int page = (int)homeProArr.count-1;
    CGFloat x = page * _midViewScrollView.frame.size.width;
    [_midViewScrollView  setContentOffset:CGPointMake(x, 0) animated:NO];
    _pagecontrol.currentPage = page;
    
}
-(void)leftmidViewAction{
    NSLog(@"left");
    int page = 0;
    CGFloat x = page * _midViewScrollView.frame.size.width;
    [_midViewScrollView  setContentOffset:CGPointMake(x, 0) animated:NO];
    _pagecontrol.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"------1");
    [self removeTimer];
    CGFloat scrollviewW =  scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    if (scrollView == _imageScrollView) {
        if (page == 0) {
            UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightimageAction)];
            
            [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
            [_imageScrollView addGestureRecognizer:rightRecognizer];
        }else if (page == _imageArray.count -1){
            UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftimageAction)];
            
            [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [_imageScrollView addGestureRecognizer:leftRecognizer];
        }
    }else if(scrollView == _midViewScrollView){
        if (page == 0) {
            UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightmidViewAction)];
            
            [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
            [_midViewScrollView addGestureRecognizer:rightRecognizer];
        }else if (page == homeProArr.count -1){
            UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftmidViewAction)];
            
            [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
            [_midViewScrollView addGestureRecognizer:leftRecognizer];
        }
    
    }
    
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"------3");
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"------2");
    [self addTimer];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
