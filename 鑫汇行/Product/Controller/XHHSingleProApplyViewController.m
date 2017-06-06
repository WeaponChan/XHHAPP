//
//  XHHSingleProApplyViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/16.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHSingleProApplyViewController.h"
#import "Masonry.h"
#import "XHHSingleProApplyTableViewCell.h"
#import "XHHSingleProApplyImgTableViewCell.h"
#import "XHHApplyImgCollectionViewCell.h"
#import "XHHApplyBtnTableViewCell.h"
#import "XHHSingleProViewController.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "UIImageView+WebCache.h"
#define CELL_WIDTH (ScreenWidth - 120) / 3

@interface XHHSingleProApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegateFlowLayout>{
    UIImage *selectimage0;
    UIImage *selectimage1;
    UIImage *selectimage2;
    UIImage *selectimage3;
    UIImage *selectimage4;
    UIImage *selectimage5;
    UIImage *selectimage6;
    UIImage *selectimage7;
    UIImage *selectimage8;
    BOOL isSelectImg0;
    BOOL isSelectImg1;
    BOOL isSelectImg2;
    BOOL isSelectImg3;
    BOOL isSelectImg4;
    BOOL isSelectImg5;
    BOOL isSelectImg6;
    BOOL isSelectImg7;
    BOOL isSelectImg8;
    NSString *imgStr0;
    NSString *imgStr1;
    NSString *imgStr2;
    NSString *imgStr3;
    NSString *imgStr4;
    NSString *imgStr5;
    NSString *imgStr6;
    NSString *imgStr7;
    NSString *imgStr8;
    int selectindex;
    
    NSString *pro_id;
    NSString *pro_name;
    
    UITextField *user_name;
    UITextField *icard;
    UITextField *tel_phone;
    UITextField *order_money;
    
    NSString *listStr;
    NSString *urlStr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *pro_applyArr;

@end
static int count = 4;
@implementation XHHSingleProApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[XHHSingleProViewController class]]) {
            XHHSingleProViewController *provc = (XHHSingleProViewController *)vc;
            pro_id = provc.pro_id;
            pro_name = provc.pro_name;
            break;
        }
    }
    _pro_applyArr = [NSMutableArray array];
    [self loadData];
    [self setTableView];
    [self setTextView];
    [self showLoadingView];
}

-(void)loadData{
    NSLog(@"---->pro_id=%@",pro_id);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1005&pro_id=%@",XHHBaseUrl,pro_id];
    [LhkhHttpsManager requestWithURLString:url parameters:nil type:1 success:^(id responseObject) {
        NSLog(@"-----SingleProApply=%@",responseObject);
        [_pro_applyArr removeAllObjects];
        
        NSArray *arr = responseObject[@"list"][@"pro_apply"];
        [_pro_applyArr addObjectsFromArray:arr];
        NSLog(@"_pro_applyArr===%@",_pro_applyArr);
        [self.tableView reloadData];
        [self closeLoadingView];
        
    } failure:^(NSError *error) {
        [self closeLoadingView];
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [tableView registerNib:[UINib nibWithNibName:@"XHHSingleProApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHSingleProApplyTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"XHHSingleProApplyImgTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHSingleProApplyImgTableViewCell"];
        [tableView registerNib:[UINib nibWithNibName:@"XHHApplyBtnTableViewCell" bundle:nil] forCellReuseIdentifier:@"XHHApplyBtnTableViewCell"];
        tableView.backgroundColor = RGBA(237, 237, 237, 1);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(35);
        make.bottom.mas_equalTo(self.view).offset(-64);
    }];
    
}

-(void)setTextView{
    user_name = [[UITextField alloc] initWithFrame:CGRectZero];
    icard = [[UITextField alloc] initWithFrame:CGRectZero];
    tel_phone = [[UITextField alloc] initWithFrame:CGRectZero];
    order_money = [[UITextField alloc] initWithFrame:CGRectZero];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"XHHSingleProApplyTableViewCell" ;
        XHHSingleProApplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        if (indexPath.row == 0) {
            cell.nameLab.text = @"姓名";
            user_name.placeholder = @"请输入您的真实姓名";
            user_name.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:user_name];
            [user_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                make.centerY.mas_equalTo(cell.nameLab);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(cell).mas_equalTo(-10);
            }];
        }else if (indexPath.row == 1){
            cell.nameLab.text = @"身份证";
            icard.placeholder = @"请输入您的身份证号";
            icard.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:icard];
            [icard mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                make.centerY.mas_equalTo(cell.nameLab);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(cell).mas_equalTo(-10);
            }];
        }else if (indexPath.row == 2){
            cell.nameLab.text = @"手机号";
            tel_phone.placeholder = @"请输入您的手机号";
            tel_phone.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:tel_phone];
            [tel_phone mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                make.centerY.mas_equalTo(cell.nameLab);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(cell).mas_equalTo(-10);
            }];
        }else if (indexPath.row == 3){
            cell.nameLab.text = @"申请金额";
            order_money.placeholder = @"请输入您要申请的金额";
            order_money.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:order_money];
            [order_money mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.nameLab.mas_right).offset(10);
                make.centerY.mas_equalTo(cell.nameLab);
                make.height.mas_equalTo(30);
                make.right.mas_equalTo(cell).mas_equalTo(-10);
            }];
        }else{
            cell.nameLab.text = @"产品名称";
            cell.nameText.hidden = NO;
            cell.nameText.text = pro_name;
            cell.nameText.enabled = NO;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *CellIdentifier = @"XHHSingleProApplyImgTableViewCell" ;
        XHHSingleProApplyImgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.applyImgCollectionView.delegate = self;
        cell.applyImgCollectionView.dataSource = self;
        [cell.applyImgCollectionView registerNib:[UINib  nibWithNibName:@"XHHApplyImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"XHHApplyImgCollectionViewCell"];
        if (isSelectImg0 == YES || isSelectImg1 == YES || isSelectImg2 == YES|| isSelectImg3 == YES|| isSelectImg4 == YES|| isSelectImg5 == YES|| isSelectImg6 == YES|| isSelectImg7 == YES|| isSelectImg8 == YES) {
            [cell.applyImgCollectionView reloadData];
        }
        [cell.applyImgCollectionView reloadData];
        return cell;
    }else{
        static NSString * CellIdentifier = @"XHHApplyBtnTableViewCell";
        XHHApplyBtnTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            NSArray *array = [[NSBundle mainBundle]loadNibNamed: CellIdentifier owner:self options:nil];
            cell = [array objectAtIndex:0];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.applyblock = ^(){
            NSLog(@"-----点击了申请");
            [self applyAct];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    if (indexPath.section == 0) {
        return 44;
    }else if(indexPath.section == 1){
        return CELL_WIDTH*((_pro_applyArr.count +2)/3)+80;
    }else{
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if(section == 1){
        return 15;
    }else{
        return 1;
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _pro_applyArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XHHApplyImgCollectionViewCell *cell = (XHHApplyImgCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"XHHApplyImgCollectionViewCell" forIndexPath:indexPath];
    collectionView.scrollEnabled = NO;
    NSDictionary *dic = nil;
    if (_pro_applyArr.count >0) {
       dic = _pro_applyArr[indexPath.row];
    }
    
    if (indexPath.row == 0) {
        
        if (selectimage0) {
            cell.addImg.hidden = NO;
            cell.addImg.image = selectimage0;
//            [cell.addImg sd_setImageWithURL:[NSURL URLWithString:imgStr0] placeholderImage:[UIImage imageNamed:@""]];
            cell.addLab.hidden = YES;
            cell.plusImg.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
        
    }else if (indexPath.row == 1){
        if (selectimage1) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage1;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 2){
        
        if (selectimage2) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage2;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 3){
        
        if (selectimage3) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage3;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 4){
        
        if (selectimage4) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage4;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 5){
        
        if (selectimage5) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage5;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 6){
        
        if (selectimage6) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage6;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 7){
        
        if (selectimage7) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage7;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }else if (indexPath.row == 8){
        
        if (selectimage8) {
            cell.addImg.hidden = NO;
            cell.plusImg.hidden = YES;
            cell.addImg.image = selectimage8;
            cell.addLab.hidden = YES;
        }else{
            cell.addLab.hidden = NO;
            cell.addLab.text = dic[@"name"];
            cell.addImg.hidden = YES;
            cell.plusImg.hidden = NO;
        }
        
    }
    
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"----->%ld",indexPath.row);
    selectindex = indexPath.row;
    NSDictionary *dic = _pro_applyArr[indexPath.row];
    NSString *str = dic[@"name"];
    if (listStr == nil) {
       listStr = [NSString stringWithFormat:@"%@",str];
    }else{
       listStr = [NSString stringWithFormat:@"%@,%@",listStr,str];
    }
    NSLog(@"----listStr=%@",listStr);
    [self selectImage];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
 
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30.f;
}


-(void)selectImage{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册上传" otherButtonTitles:@"拍照上传", nil];
    [sheet showInView:self.view];
}

#pragma UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger sourcetype = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
                case 2:
                return;
                break;
                case 1:
                sourcetype = UIImagePickerControllerSourceTypeCamera;
                break;
                case 0:
                sourcetype = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                break;
        }
    }else{
        if (buttonIndex == 2) {
            return;
        }else{
            sourcetype = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    UIImagePickerController *imggePickerVc = [[UIImagePickerController alloc]init];
    imggePickerVc.delegate = self;
    imggePickerVc.allowsEditing = NO;
    imggePickerVc.sourceType = sourcetype;
    [self presentViewController:imggePickerVc animated:NO completion:nil];
}

#pragma UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    NSString *picStr = [data base64EncodedStringWithOptions:0];
    [self uploadImg:picStr image:image];
    
    
}

-(void)uploadImg:(NSString*)imagestr image:(UIImage*)image{
    NSMutableDictionary *modifyparams = [NSMutableDictionary  dictionary];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"User"];
    modifyparams[@"action"] = @(1016);
    modifyparams[@"key"] = KEY;
    modifyparams[@"phone"] = @(11377606508);
    //user.integerValue
    modifyparams[@"user_id"] = @(1);
    modifyparams[@"pic"] = imagestr;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1016&key=%@&phone=11377606508",XHHBaseUrl,KEY];
    NSLog(@"----params=%@",modifyparams);
    [LhkhHttpsManager requestWithURLString:url parameters:modifyparams type:2 success:^(id responseObject) {
        NSLog(@"-----myinfo=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                NSString *listUrl = responseObject[@"list"];
                if (selectindex == 0) {
                    selectimage0 = image;
                    imgStr0 = listUrl;
                    isSelectImg0 = YES;
                }else if (selectindex == 1){
                    selectimage1 = image;
                    imgStr1 = listUrl;
                    isSelectImg1 = YES;
                }else if (selectindex == 2){
                    selectimage2 = image;
                    imgStr2 = listUrl;
                    isSelectImg2 = YES;
                }else if (selectindex == 3){
                    selectimage3 = image;
                    imgStr3 = listUrl;
                    isSelectImg3 = YES;
                }else if (selectindex == 4){
                    selectimage4 = image;
                    imgStr4 = listUrl;
                    isSelectImg4 = YES;
                }else if (selectindex == 5){
                    selectimage5 = image;
                    imgStr5 = listUrl;
                    isSelectImg5 = YES;
                }else if (selectindex == 6){
                    selectimage6 = image;
                    imgStr6 = listUrl;
                    isSelectImg6 = YES;
                }else if (selectindex == 7){
                    selectimage7 = image;
                    imgStr7 = listUrl;
                    isSelectImg7 = YES;
                }else{
                    selectimage8 = image;
                    imgStr8 = listUrl;
                    isSelectImg8 = YES;
                }
                if (urlStr == nil) {
                    urlStr = [NSString stringWithFormat:@"%@",listUrl];
                }else{
                    urlStr = [NSString stringWithFormat:@"%@,%@",urlStr,listUrl];
                }
                NSLog(@"----->urlStr=%@",urlStr);
                [self.tableView reloadData];
                [MBProgressHUD show:@"上传成功" view:self.view];
            }else{
                [MBProgressHUD show:@"上传失败，请重新上传" view:self.view];
            }
        }else{
            [MBProgressHUD show:@"上传失败，请重新上传" view:self.view];
        }
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}


//申请
-(void)applyAct{
    NSLog(@"user_name===%@",user_name.text);
    NSMutableDictionary *applyparams = [NSMutableDictionary  dictionary];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"User"];
    applyparams[@"action"] = @(1017);
    applyparams[@"key"] = KEY;
    applyparams[@"phone"] = @(11377606508);
    applyparams[@"tel_phone"] = @(tel_phone.text.integerValue);
    applyparams[@"user_name"] = user_name.text;
    applyparams[@"icard"] = icard.text;
    applyparams[@"order_money"] = @(order_money.text.integerValue);
    applyparams[@"material_name"] = listStr;
    applyparams[@"material_pic"] = [NSString stringWithFormat:@"%@,%@,%@",imgStr0,imgStr1,imgStr2];
    applyparams[@"pro_id"] = @(pro_id.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1017&key=%@&phone=11377606508",XHHBaseUrl,KEY];
    NSLog(@"----params=%@",applyparams);
    [LhkhHttpsManager requestWithURLString:url parameters:applyparams type:2 success:^(id responseObject) {
        NSLog(@"-----apply=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                
                [MBProgressHUD show:@"申请成功" view:self.view];
            }else{
                [MBProgressHUD show:@"申请失败，请重新申请" view:self.view];
            }
        }else{
            [MBProgressHUD show:@"申请失败，请重新申请" view:self.view];
        }
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];

}

-(NSMutableArray*)pro_applyArr{

    if (_pro_applyArr == nil) {
        _pro_applyArr = [NSMutableArray array];
    }
    return _pro_applyArr;
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
