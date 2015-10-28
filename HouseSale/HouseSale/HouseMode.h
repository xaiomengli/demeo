//
//  HouseMode.h
//  HouseSale
//
//  Created by qingyun on 15/10/13.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseMode : NSObject

@property(nonatomic,strong) NSString *nid,*title,*housetype,*iconurl,*community,*cid,*simpleadd,*camera;

@property(nonatomic,assign)int temprownumber,totalprice,area;


-(instancetype)initWithValue:(NSDictionary *)dic;



//@property(nonatomic,strong)
//@property(nonatomic,strong)
//@property(nonatomic,strong)
//@property(nonatomic,strong)
//@property(nonatomic,strong)
//@property(nonatomic,strong)

@end
