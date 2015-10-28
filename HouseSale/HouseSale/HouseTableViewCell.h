//
//  HouseTableViewCell.h
//  HouseSale
//
//  Created by qingyun on 15/10/13.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HouseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *pLab;//片
@property (weak, nonatomic) IBOutlet UILabel *qLab;//区
@property (weak, nonatomic) IBOutlet UILabel *typeLab;//户型
@property (weak, nonatomic) IBOutlet UILabel *areaLab;//面积
@property (weak, nonatomic) IBOutlet UILabel *priceLab;//价格



@end
