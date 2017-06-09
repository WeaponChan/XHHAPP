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
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    modifyparams[@"action"] = @(1016);
    modifyparams[@"key"] = user_key;
    modifyparams[@"phone"] = @(user.integerValue);
    //user.integerValue
    modifyparams[@"user_id"] = @(user_id.integerValue);
    modifyparams[@"pic"] = imagestr;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1016&key=%@&phone=%@",XHHBaseUrl,user_key,user];
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
    NSString *regex = @"[a-zA-Z. ]*";
    NSPredicate *Engpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *Zhpredicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    NSString *num = @"[0-9]";
    NSPredicate *Numgpredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", num];
    NSString *namestr = user_name.text;
    if (user_name.text == nil || [user_name.text isEqualToString:@""]) {
        [MBProgressHUD show:@"姓名不能为空" view:self.view];
        return;
    }
    if (user_name.text.length < 2 || user_name.text.length >30) {
        [MBProgressHUD show:@"姓名长度不能低于2且不能大于30，请重新修改" view:self.view];
        return;
    }
    if ([Engpredicate evaluateWithObject:namestr] == NO && [Zhpredicate evaluateWithObject:namestr] == NO) {
        [MBProgressHUD show:@"姓名只能是全英文或者全汉字,请修改!" view:self.view];
        return;
    }
    if (icard.text == nil || [icard.text isEqualToString:@""]) {
        [MBProgressHUD show:@"身份证号码不能为空" view:self.view];
        return;
    }
    
    if ([self judgeIdentityStringValid:icard.text] == NO) {
        [MBProgressHUD show:@"身份证号码格式不对" view:self.view];
        return;
    }
    
    if (tel_phone.text.length !=11 || tel_phone.text == nil || [tel_phone.text isEqualToString:@""]) {
        [MBProgressHUD show:@"手机号格式错误，请重新填写" view:self.view];
        return;
    }
    if ([Numgpredicate evaluateWithObject:tel_phone.text] == YES) {
        [MBProgressHUD show:@"手机号只能是数字，请重新填写" view:self.view];
        return;
    }
    if (order_money.text == nil || [order_money.text isEqualToString:@""] || [Numgpredicate evaluateWithObject:order_money.text] == YES) {
        [MBProgressHUD show:@"申请金额格式有误，请正确填写" view:self.view];
        return;
    }
    
    NSMutableDictionary *applyparams = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    applyparams[@"action"] = @(1017);
    applyparams[@"key"] = user_key;
    applyparams[@"phone"] = @(user.integerValue);
    applyparams[@"tel_phone"] = @(tel_phone.text.integerValue);
    applyparams[@"user_name"] = user_name.text;
    applyparams[@"icard"] = icard.text;
    applyparams[@"order_money"] = @(order_money.text.integerValue);
    applyparams[@"material_name"] = listStr;
    applyparams[@"material_pic"] = [NSString stringWithFormat:@"%@,%@,%@",imgStr0,imgStr1,imgStr2];
    applyparams[@"pro_id"] = @(pro_id.integerValue);
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1017&key=%@&phone=%@",XHHBaseUrl,user_key,user];
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
