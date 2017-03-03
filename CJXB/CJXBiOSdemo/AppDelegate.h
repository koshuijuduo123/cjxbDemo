//
//  AppDelegate.h
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/8/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class CarEntity;
@class CarModel;
@class MessageModel;
@class ResultData;
@class MessageData;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic,copy)NSString *articleId;//分享文章ID



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
//传递文章ID
-(void)setNSString:(NSString *)string;

//添加驾驶证实体
-(void)addMessageEntity:(MessageData *)model;
//查询实体
-(NSArray *)searchMessageEntity;

-(void)updataMessage:(NSString *)ljjf with:(NSString *)zt;

//添加违章记录实体
-(void)addCarInfoEntity:(ResultData *)model;
//查询实体
-(NSArray *)searchCarinfoEntity;

//添加车辆实体
-(void)addMovEntiityWith:(CarModel *)model;


//查询实体
-(NSArray *)searchMovieEntiity;

-(void)updataWith:(NSString *)str with:(NSString *)fkje with:(NSString *)fkjfs with:(NSString *)count;

+(void)showAlertMessageWithMessage:(NSString*)message duration:(NSTimeInterval)time;

@end

