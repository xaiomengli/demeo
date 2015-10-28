//
//  ViewController.m
//  HouseSale
//
//  Created by qingyun on 15/10/13.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "HouseTableViewCell.h"
#import "Header.h"
#import "HouseMode.h"
#import "DBhandleOperation.h"
#import "QYOperationFile.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArr;//数据源



@property(nonatomic,strong)NSMutableDictionary *taskDic;

@end

@implementation ViewController


-(void)DataForMode:(NSData *)data{
    NSError *error;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSArray *tempArr=dic[@"RESPONSE_BODY"][@"list"];
    for (NSDictionary *tempDic in tempArr) {
        //把字典的数据存入到数据库
        [[DBhandleOperation shareDB] insertIntoForMode:tempDic];

        HouseMode *mode=[[HouseMode alloc] initWithValue:tempDic];
        [_dataArr addObject:mode];
    }
}


#pragma mark 网络请求
-(void)requestNetWork{
  /*
   * 异步的操作 GCD(队列)
   *（子线程）
   * 网络获取数据
   * 数据解析json——》字典
   * list数据（字典）——》mode--》dataArr
   *（主线程）
   * 刷新ui
   */
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //1网络请求
       NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
       request.HTTPMethod=@"post";
       NSString *bodyStr=@"HEAD_INFO={\"commandcode\":102,\"REQUEST_BODY\":{\"city\":\"昆明\",\"desc\":\"1\" ,\"p\":10}}";
       request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
     
       NSHTTPURLResponse *response;
       NSError *error;
       NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
       if (response.statusCode==200) {
           //解析json
           
           //将数据源保存在本地
//           if([QYOperationFile saveFile:@"housedata" directory:FilePage fileObjc:data]) {
//           }
           
          //字典转模型 并 将数据源保存在本地数据库
           [self DataForMode:data];
       
           dispatch_sync(dispatch_get_main_queue(), ^{
               //2.刷新ui
               UITableView *table=(UITableView *)[self.view viewWithTag:10];
               [table reloadData];
           });
 
           
       }
   });

}

#pragma mark 下载图片
-(void)loadImageForURL:(NSString *)url forid:(NSIndexPath *)path{
/* GCD
 *（异步）启动一个新线程来下载
 *1网络下载
 *
 *2刷新ui（imageview）
 */
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     //1.下载image
       NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
       //判读文件是否下载完毕
       if(data){
       //保存本地
        //保存文件的名称
         NSString *filename=[[[[url componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject];
           if(![QYOperationFile saveFile:filename directory:IMAGPAGE fileObjc:data]){
               NSLog(@"====保存失败");
               
           }
           //移除下载任务标签
           [_taskDic removeObjectForKey:path];
       }
       
       //更新我们的ui
        dispatch_sync(dispatch_get_main_queue(), ^{
            UITableView *table=(UITableView *)[self.view viewWithTag:10];
            HouseTableViewCell *cell=(HouseTableViewCell *)[table cellForRowAtIndexPath:path];
            cell.iconImageView.image=[UIImage imageWithData:data];
            
        });
   });
}





- (void)viewDidLoad {
    _taskDic=[NSMutableDictionary dictionary];
    //读取我们的网络请求的本地数据
    _dataArr=[[DBhandleOperation shareDB] selectAll];
    
    UITableView *tableView=[[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.rowHeight=100;
    tableView.tag=10;
    [self.view addSubview:tableView];
    [super viewDidLoad];
    //1网络请求数据
    if (!_dataArr) {
        [self requestNetWork];

   }
   
    _dataArr=[[DBhandleOperation shareDB] selectAll];
    

    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark dataSource Delegate;

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"HouseTableViewCell" owner:self options:nil][0];
    }
    //1取出模型mode
    HouseMode *mode=_dataArr[indexPath.row];
    
    //2mode赋值给cell
    cell.titleLab.text=mode.title;
    cell.qLab.text=mode.community;
    cell.pLab.text=mode.simpleadd;
    cell.typeLab.text=mode.housetype;
    cell.areaLab.text=[NSString stringWithFormat:@"%d平米",mode.area];
    cell.priceLab.text=[NSString stringWithFormat:@"%d万",mode.totalprice];
    
    //下载图片icon
     cell.iconImageView.image=[UIImage imageNamed:@"Icon-60@3x"];
    if (mode.iconurl.length>0) {
    //1获取image的名称
    NSString *imageName=[[[[mode.iconurl componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"."] firstObject];
       
        //读取本地是否有该文件
        NSData *imageData=[QYOperationFile getFile:imageName directory:IMAGPAGE];
        if (imageData) {
            //本地有改文件 转换成image
            cell.iconImageView.image=[UIImage imageWithData:imageData];
        }else{
          //网络加载
          
        NSString *task=_taskDic[indexPath];
         if (!task) {
           NSString *url=[NSString stringWithFormat:@"%@%@",baseImageURL,mode.iconurl];
          [self loadImageForURL:url forid:indexPath];
          //把我们的下载的任务标识放在我们的字典里边
             [_dataArr indexOfObject:indexPath];
             
             
          [_taskDic setObject:@"1" forKey:indexPath];
        }
        }
    }
    return cell;
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
