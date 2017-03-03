//
//  StringUtils.m
//  TestWeizhang1
//
//  Created by AceBlack on 15/12/9.
//  Copyright © 2015年 wang. All rights reserved.
//

#import "StringUtils.h"

#import "MyMD5.h"
@implementation StringUtils
+(NSString *)getAuthJsonObject:(NSString *)paramstr{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *datetime = [formatter stringFromDate:[NSDate date]];
    
    NSString *str4=@"";
    NSString *paramString =[NSString stringWithFormat:@"%@%@%@%@%@",datetime,str4,@"-1",@"Aafd#/l1%rIn",paramstr];
    
    NSString *jsonStr = [NSString stringWithFormat:@"{\"app_key\":\"123456\",\"imei\":\"\",\"os\":\"ios\",\"os_version\":\"2\",\"app_version\":\"0.9\",\"ver\":\"0.9\",\"crc\":\"%@\",\"time_stamp\":\"%@\"}",[MyMD5 md5:paramString],datetime];
    
    return jsonStr;
}


@end
