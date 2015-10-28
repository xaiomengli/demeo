//
//  DBhandleOperation.h
//  HouseSale
//
//  Created by qingyun on 15/10/22.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HouseMode;

@interface DBhandleOperation : NSObject
/*
 * 单例
 */
+(instancetype)shareDB;
/*
 *插入数据
 */
-(BOOL)insertIntoForMode:(NSDictionary *)mode;
 /*
 *查询数据
 */
-(NSMutableArray *)selectAll;
@end
