//
//  XHHRegisterViewController.m
//  鑫汇行
//
//  Created by LHKH on 2017/5/15.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "XHHRegisterViewController.h"
#import "XHHNoteViewController.h"

@interface XHHRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *cityText;
@property (weak, nonatomic) IBOutlet UITextField *tuijianNumText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation XHHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    self.registerBtn.layer.cornerRadius = 4.f;
    self.registerBtn.layer.masksToBounds = YES;
}
- (IBAction)changeCityClick:(id)sender {
}
- (IBAction)scanClick:(id)sender {
}
- (IBAction)registerClick:(id)sender {
}
- (IBAction)checkClick:(id)sender {
}
- (IBAction)xhhNoteClick:(id)sender {
    XHHNoteViewController *vc = [[XHHNoteViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
