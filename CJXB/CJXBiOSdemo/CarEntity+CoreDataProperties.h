//
//  CarEntity+CoreDataProperties.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/9/22.
//  Copyright © 2016年 wang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *count;
@property (nullable, nonatomic, retain) NSString *fkje;
@property (nullable, nonatomic, retain) NSString *hphm;
@property (nullable, nonatomic, retain) NSString *hpzl;
@property (nullable, nonatomic, retain) NSString *wfjfs;
@property (nullable, nonatomic, retain) NSString *hp;
@property (nullable, nonatomic, retain) NSString *mm;
@property (nullable, nonatomic, retain) NSString *lz;

@end

NS_ASSUME_NONNULL_END
