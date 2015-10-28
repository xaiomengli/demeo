//
//  QYOperationFile.h
//  HouseSale
//
//  Created by qingyun on 15/10/17.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYOperationFile : NSObject


//+(BOOL)saveArrFile:(NSString *)fileName directory:(NSString *)directory fileObjc:(NSMutableArray *)file;

//+(NSString  *)getFilePath:(NSString *)fileName directory:(NSString *)directory;
/* 保存文件
 * @pragma fileName 保存的文件名
 * @pragma directory 文件夹名称
 * @pragma file 存储的文件对象
 * return YES/NO
 */
+(BOOL)saveFile:(NSString *)fileName directory:(NSString *)directory fileObjc:(NSData *)file;

/* 保存文件
 * @pragma fileName  文件名
 * @pragma directory 文件夹名称
 *  return  NSData
 */
+(NSData *)getFile:(NSString *)fileName directory:(NSString *)directory;


@end
