//
//  MyLoveNewsEntity+CoreDataProperties.h
//  
//
//  Created by AceBlack on 17/3/12.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyLoveNewsEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyLoveNewsEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imgUrl;
@property (nullable, nonatomic, retain) NSString *newsUrl;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *newId;
@property (nullable, nonatomic, retain) NSString *timeAdd;

@end

NS_ASSUME_NONNULL_END
