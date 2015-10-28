//
//  HouseMode.m
//  HouseSale
//
//  Created by qingyun on 15/10/13.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "HouseMode.h"

@implementation HouseMode


-(instancetype)initWithValue:(NSDictionary *)dic{
    if (self=[super init]) {
     //kvc赋值
     [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}



@end
