//
//  ResultData.h
//  TestWeizhang1
//
//  Created by AceBlack on 15/12/9.
//  Copyright © 2015年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultData : NSObject
@property(nonatomic,copy)NSString *clbj;//处理未处理
@property(nonatomic,copy)NSString *fkje;//罚款金额
@property(nonatomic,copy)NSString *hphm;//车牌号码
@property(nonatomic,copy)NSString *hpzl;
@property(nonatomic,copy)NSString *pageNo;
@property(nonatomic,copy)NSString *wfbh;
@property(nonatomic,copy)NSString *wfdz;  //违规地址
@property(nonatomic,copy)NSString *wfjfs;//罚款积分
@property(nonatomic,copy)NSString *wfsj; //违规时间
@property(nonatomic,copy)NSString *wfxw; //违规行为
@property(nonatomic,copy)NSString *wfxwdm;

//@property(nonatomic,copy)NSString *sbhm;//识别号码
@end
