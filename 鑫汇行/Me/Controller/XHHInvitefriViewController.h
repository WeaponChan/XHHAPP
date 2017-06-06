//
//  XHHInvitefriViewController.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/18.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import "LhkhBaseViewController.h"

@interface XHHInvitefriViewController : LhkhBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *headBannerImg;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImg;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (copy, nonatomic)NSString *user_id;
@end
