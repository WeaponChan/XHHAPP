//
//  XHHMyInfoViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHMyInfoViewController.h"
#import "Masonry.h"
#import "UIImage+LhkhExtension.h"
#import "UIColor+LhkhColor.h"
#import "XHHModifyInfoViewController.h"
#import "LhkhHttpsManager.h"
#import "MBProgressHUD+Add.h"
#import "XHHMyinfoModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import <AssetsLibrary/ALAsset.h>

#import <AssetsLibrary/ALAssetsLibrary.h>

#import <AssetsLibrary/ALAssetsGroup.h>

#import <AssetsLibrary/ALAssetRepresentation.h>


@interface XHHMyInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,
UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,modifyValueDelegate>{
    UIImageView *_imageView;
    UILabel *nameLab;
    UILabel *phoneLab;
    UILabel *birthdayLab;
    UILabel *sexLabel;
    UILabel *areaLabel;
    UILabel *numLab;
    UIControl *_blackView;
    NSString *dateStr;
    NSMutableArray *_dataArray;
    NSMutableArray *_citiesArray;
    NSString *proStr;
    NSString *shiStr;
    BOOL isDatePicker;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIView *datePickerView;
@property (nonatomic,strong)UIView *pickerRootView;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIPickerView *pickerView;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *modifyparams;
@property (nonatomic,strong)XHHMyinfoModel *myInfoModel;

@end

@implementation XHHMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改个人信息";
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"back_more-1"] style:UIBarButtonItemStylePlain target:self action:@selector(hide)];
    left.imageInsets = UIEdgeInsetsMake(0, 10, 0, 15);
    self.navigationItem.leftBarButtonItem = left;
    
    [self setTableView];
    [self setblackView];
    [self setDatePickerView];
    [self setPickerView];
}

-(void)hide{
    [self.parentViewController.view removeFromSuperview];
    [self.parentViewController removeFromParentViewController];
}

-(void)setTableView{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
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
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
}

-(void)setblackView{
    _blackView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -  260)];
    [_blackView addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _blackView.backgroundColor = [UIColor blackColor];
    _blackView.alpha = 0.4;
    _blackView.hidden = YES;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:_blackView];
    
}
-(void)setDatePickerView{
    
    _datePickerView = [[UIView alloc]initWithFrame:CGRectZero];
    _datePickerView.hidden = YES;
    [self.view addSubview:_datePickerView];
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
    [_datePickerView addSubview:cancelBtn];
    [_datePickerView addSubview:sureBtn];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_datePickerView).offset(15);
        make.top.mas_equalTo(_datePickerView).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_datePickerView).offset(-15);
        make.top.mas_equalTo(_datePickerView).offset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectZero];
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_datePickerView addSubview:self.datePicker];
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(260);
    }];
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_datePickerView).offset(0);
        make.height.mas_equalTo(216);
    }];
    
    
    //当前时间创建NSDate
    NSDate *localDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //设置时间
    [offsetComponents setYear:0];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:0];
    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:localDate options:0];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.maximumDate = maxDate;

}

-(void)setPickerView{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"plist"];
    _dataArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    _citiesArray = _dataArray[0][@"cities"];
    
    _pickerRootView = [[UIView alloc] initWithFrame:CGRectZero];
    _pickerRootView.hidden = YES;
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
        make.height.mas_equalTo(260);
    }];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(_pickerRootView).offset(0);
        make.height.mas_equalTo(216);
    }];
}

-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    NSLog(@"dateChanged响应事件：%@",date);
    NSDate *pickerDate = [self.datePicker date];
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
    [pickerFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    NSLog(@"格式化显示时间：%@",dateString);
    dateStr = dateString;
//    birthdayLab.text = dateString;
    
}

-(void)cancelButtonAction:(id)sender{

    _blackView.hidden = _datePickerView.hidden = _pickerRootView.hidden = YES;
}

-(void)sureButtonAction:(id)sender{
    
    _blackView.hidden = _datePickerView.hidden = _pickerRootView.hidden = YES;
    
    if (isDatePicker == YES) {
        [self modifyData:@"birth" modifyInfo:dateStr];
    }else{
        if (shiStr == nil) {
            _citiesArray = _dataArray[0][@"cities"];
            proStr = _dataArray[0][@"state"];
            shiStr = _citiesArray[0];
        }
        [self modifyData:@"city" modifyInfo:shiStr];

    }
    
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"  头像";
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-90, 10, 36, 36)];
            _imageView.layer.cornerRadius = 18.f;
            _imageView.layer.masksToBounds = YES;
            [_imageView sd_setImageWithURL:[NSURL URLWithString:self.myInfoModel.pic] placeholderImage:[UIImage imageNamed:@""]];
            UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, ScreenWidth, 1)];
            kongView.backgroundColor = RGBA(236, 236, 236, 1);
            [cell.contentView addSubview:kongView];
            [cell.contentView addSubview:_imageView];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"  姓名";
            nameLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-250, 12, 200, 20)];
            nameLab.text = self.myInfoModel.name;
            nameLab.textAlignment = NSTextAlignmentRight;
            nameLab.font = [UIFont systemFontOfSize:15];
            UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            kongView.backgroundColor = RGBA(245, 245, 245, 1);
            [cell.contentView addSubview:nameLab];
            [cell.contentView addSubview:kongView];
            
            
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"  手机";
            phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 12, 200, 20)];
            NSString *str = self.myInfoModel.phone;
            if (str && ![str isEqualToString:@""]) {
                NSMutableString *Mutablestr = [NSMutableString stringWithString:str];
                [Mutablestr replaceCharactersInRange:NSMakeRange(3, 4)withString:@"****"];
                NSString *newsfzstr = [Mutablestr copy];
                phoneLab.text = newsfzstr;
            }else{
                phoneLab.text = @"";
            }
            phoneLab.textAlignment = NSTextAlignmentRight;
            phoneLab.font = [UIFont systemFontOfSize:15.0];
            UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            kongView.backgroundColor = RGBA(245, 245, 245, 1);
            [cell.contentView addSubview:kongView];
            [cell.contentView addSubview:phoneLab];
            
        }else if (indexPath.row == 3){
            cell.textLabel.text = @"  生日";
            birthdayLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 12, 200, 20)];
            birthdayLab.textAlignment = NSTextAlignmentRight;
            birthdayLab.font = [UIFont systemFontOfSize:15.0];
            birthdayLab.text = self.myInfoModel.birth;
            UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            kongView.backgroundColor = RGBA(245, 245, 245, 1);
            [cell.contentView addSubview:kongView];
            [cell.contentView addSubview:birthdayLab];
            
        }else if (indexPath.row == 4){
            cell.textLabel.text = @"  城市";
            areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 12, 200, 20)];
            areaLabel.text = self.myInfoModel.city;
            areaLabel.textAlignment = NSTextAlignmentRight;
            areaLabel.font = [UIFont systemFontOfSize:15.0];
            UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
            kongView.backgroundColor = RGBA(245, 245, 245, 1);
            [cell.contentView addSubview:kongView];
            [cell.contentView addSubview:areaLabel];
            
        }
    }else{
        cell.textLabel.text = @"  我的推荐人";
        numLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 250, 12, 200, 20)];
        numLab.text = self.myInfoModel.rec_name;
        numLab.textAlignment = NSTextAlignmentRight;
        numLab.font = [UIFont systemFontOfSize:15.0];
        UIView * kongView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        kongView.backgroundColor = RGBA(245, 245, 245, 1);
        [cell.contentView addSubview:kongView];
        [cell.contentView addSubview:numLab];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4 ) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 56;
        }else{
            return 44;
        }
    }else{
        return 44;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else{
        return 15;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self selectImage];
        }else if (indexPath.row == 1){
            XHHModifyInfoViewController *vc = [[XHHModifyInfoViewController alloc] init];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:NO];
        }else if (indexPath.row == 3){
            isDatePicker = YES;
            _blackView.hidden = _datePickerView.hidden = NO;
        }else if (indexPath.row == 4){
            isDatePicker = NO;
            _blackView.hidden = _pickerRootView.hidden = NO;
        }
    }

}

-(void)modifyValue:(NSString *)value{
    [self modifyData:@"name" modifyInfo:value];
//    nameLab.text = value;
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
    /*
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
        NSLog(@"fileName : %@",fileName);
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];*/
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    NSString *picStr = [data base64EncodedStringWithOptions:0];
    
    [self modifyData:@"pic" modifyInfo:picStr];
    [picker dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark- UIPickerViewDataSource and UIPickerViewDelegate
- (void)loadData {
    
    NSMutableDictionary *params = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    params[@"action"] = @(1010);
    params[@"key"] = user_key;
    params[@"phone"] = @(user.integerValue); //user.integerValue
    self.params = params;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1010&key=%@&phone=%@",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:params type:1 success:^(id responseObject) {
        NSLog(@"-----myinfo=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            self.myInfoModel = [XHHMyinfoModel mj_objectWithKeyValues:responseObject[@"list"]];
            [self.tableView reloadData];
        }
        else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
            
        }else{
            [MBProgressHUD show:responseObject[@"msg"] view:self.view];
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

-(void)login{
    [(AppDelegate *)[UIApplication sharedApplication].delegate openLoginCtrl];
}

-(void)modifyData:(NSString*)modifyStr modifyInfo:(NSString*)modifyInfo{
    NSMutableDictionary *modifyparams = [NSMutableDictionary  dictionary];
    NSString *user_id =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_ID"];
    NSString *user =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER"];
    NSString *user_key =  [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_KEY"];
    modifyparams[@"action"] = @(1010);
    modifyparams[@"key"] = user_key;
    modifyparams[@"phone"] = @(user.integerValue);
    //user.integerValue
    modifyparams[@"user_id"] = @(self.myInfoModel.ID.integerValue);
    modifyparams[@"do"] = @(3);
    modifyparams[modifyStr] = modifyInfo;
    self.modifyparams = modifyparams;
    NSString *url = [NSString stringWithFormat:@"%@/app.php/WebService?action=1010&key=%@&phone=%@&do=3",XHHBaseUrl,user_key,user];
    [LhkhHttpsManager requestWithURLString:url parameters:modifyparams type:2 success:^(id responseObject) {
        NSLog(@"-----myinfo=%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            if (responseObject[@"list"]) {
                if ([modifyStr isEqualToString:@"name"]) {
                    nameLab.text = modifyInfo;
                }else if ([modifyStr isEqualToString:@"birth"]){
                    birthdayLab.text = dateStr;
                }else if ([modifyStr isEqualToString:@"pic"]){
                    [_imageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"list"]] placeholderImage:[UIImage imageNamed:@""]];
                }else{
                    areaLabel.text = [NSString stringWithFormat:@"%@ %@",proStr,shiStr];
                }
               [MBProgressHUD show:@"修改成功" view:self.view];
            }else{
                [MBProgressHUD show:@"修改失败，请重新修改" view:self.view];
            }
        }else if ([responseObject[@"status"] isEqualToString:@"3"]){
            
            [MBProgressHUD show:@"登录身份已失效，请重新登录" view:self.view];
            [self performSelector:@selector(login) withObject:self afterDelay:2.f];
        }else{
            [MBProgressHUD show:@"修改失败，请重新修改" view:self.view];
        }
    } failure:^(NSError *error) {
        NSString *str = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD show:str view:self.view];
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _dataArray.count;
    }else {
        return _citiesArray.count;
    }
}

#pragma mark - delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 150;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 60;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%@",_dataArray[row][@"state"]];
    }else {
        return [NSString stringWithFormat:@"%@",_citiesArray[row]];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _citiesArray = _dataArray[row][@"cities"];
        proStr = _dataArray[row][@"state"];
        [_pickerView reloadComponent:1];
        shiStr = _citiesArray[0];
        
    }else{
        shiStr = _citiesArray[row];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
