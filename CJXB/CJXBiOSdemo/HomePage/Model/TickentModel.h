//
//  TickentModel.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/1.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "BaseModel.h"

@interface TickentModel : BaseModel
@property(nonatomic,copy)NSString *baddress;

@property(nonatomic,copy)NSString *bimg;

@property(nonatomic,copy)NSString *bname;

@property(nonatomic,copy)NSString *bsummary;

@property(nonatomic,copy)NSString *name;

@property(nonatomic,strong)NSArray *phone;

@property(nonatomic,assign)CGFloat poinx;
@property(nonatomic,assign)CGFloat poiny;





@end
