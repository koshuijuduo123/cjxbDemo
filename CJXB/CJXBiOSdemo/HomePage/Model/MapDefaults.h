//
//  MapDefaults.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/2.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapModel.h"
@interface MapDefaults : NSObject

+(MapDefaults *)standInstance;



-(void)setDataWith:(MapModel *)model;

-(NSString *)sentDataWith;




@end
