//
//  XHHHelpCenterTableViewCell.h
//  鑫汇行
//
//  Created by LHKH on 2017/5/22.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^OpenCellBlock)();
@interface XHHHelpCenterTableViewCell : UITableViewCell
@property(copy,nonatomic)OpenCellBlock opencellBlock;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouImg;
@property (weak, nonatomic) IBOutlet UILabel *qusLab;
@property (weak, nonatomic) IBOutlet UILabel *answerLab;
@end
