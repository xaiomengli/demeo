//
//  DBhandleOperation.m
//  HouseSale
//
//  Created by qingyun on 15/10/22.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "DBhandleOperation.h"
#import "FMDB.h"
#import "HouseMode.h"


@interface DBhandleOperation ()
@property(nonatomic,strong)FMDatabase *db;
@end

@implementation DBhandleOperation

+(instancetype)shareDB{
    static DBhandleOperation *opeartion;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        opeartion=[[DBhandleOperation alloc] init];
        //创建表
        [opeartion creatTable];
    });
    return opeartion;
}

-(BOOL)creatDB{
    if (!_db) {
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"house.DB"];
        _db=[FMDatabase databaseWithPath:path];
        return YES;
    }
    return NO;
}

-(BOOL)creatTable{
    
    if (![self creatDB]) {
        return NO;
    }
    
//1打开数据库
    if (![_db open]) {
        return NO;
    }
    NSString *sql=@"create table if not exists house(nid text,title text,iconurl text,housetype text,community text,cid text,simpleadd text,camera text,temprownumber integer,totalprice integer,area integer)";
    
   //执行sql语句
    if (![_db executeUpdate:sql]){
        NSLog(@"失败");
        [_db close];
        return NO;
    }
    //关闭数据库
    [_db close];
    return YES;

}

-(BOOL)insertIntoForMode:(NSDictionary *)mode{
 //1打开数据库
    if ( ![_db    open]) {
        return NO;
    };
 //2sql
   NSString *sql=@"insert into house (nid,title,iconurl,housetype,community,cid,simpleadd,camera,temprownumber,totalprice,area)values (:nid,:title,:iconurl,:housetype,:community,:cid,:simpleadd,:camera,:temprownumber,:totalprice,:area)";
 //3执行sql
    if (![_db executeUpdate:sql withParameterDictionary:mode]) {
        NSLog(@"失败插入");
        [_db close];
        return NO;
    }

 //4关闭数据库
    [_db close];
    return YES;
}

-(NSMutableArray *)selectAll{
//1打开数据库
    if (![_db open]) {
        return nil;
    }
//2sql
    NSString *sql=@"select *from house";
//3执行查询
 FMResultSet *r=[_db executeQuery:sql];
    NSMutableArray *arr=[NSMutableArray array];
    while ([r next]) {
     NSDictionary *resuteDic=[r resultDictionary];
      //kvc
        HouseMode *mode=[[HouseMode alloc] initWithValue:resuteDic];
        
        
        
        [arr addObject:mode];
    }
    
    
//4关闭数据库
    [_db close];
    return arr;
}







@end
