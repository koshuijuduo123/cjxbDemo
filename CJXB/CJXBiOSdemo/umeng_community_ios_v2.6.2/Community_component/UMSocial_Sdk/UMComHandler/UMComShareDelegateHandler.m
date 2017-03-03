//
//  UMComShareDelegatehandler.m
//  UMCommunity
//
//  Created by umeng on 16/3/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComShareDelegateHandler.h"
#import "UMComShareDelegate.h"
#import "UMSocial.h"

#import "UMComPushRequest.h"
#import "UMComFeed+UMComManagedObject.h"
#import "UMComSession.h"
#import "WXApi.h"
#import "UMComImageUrl.h"

#define MaxShareLength 137
#define MaxLinkLength 10

@interface UMComShareDelegateHandler ()
<UMComShareDelegate>

@property (nonatomic, strong) UMComFeed *feed;

@end

@implementation UMComShareDelegateHandler

static UMComShareDelegateHandler *_instance = nil;
+ (UMComShareDelegateHandler *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void)setAppKey:(NSString *)appKey
{
    [UMSocialData setAppKey:appKey];
    
    [UMSocialConfig setFinishToastIsHidden:NO position:UMSocialiToastPositionBottom];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (void)didSelectPlatformAtIndex:(NSInteger)platformIndex
                            feed:(UMComFeed *)feed
                  viewController:(UIViewController *)viewControlller
{
    NSArray *platforms = nil;
    
    if ([self isWechatInstalled]) {
        platforms = @[UMShareToSina, UMShareToWechatTimeline, UMShareToWechatSession, UMShareToQzone, UMShareToQQ];
    } else {
        platforms = @[UMShareToSina, UMShareToQzone, UMShareToQQ];
    }
    if (platformIndex < 0 || platformIndex >= platforms.count) {
        return;
    }
    NSString *platformName = platforms[platformIndex];
    UMComFeed *shareFeed = nil;
    if (feed.origin_feed) {
        shareFeed = feed.origin_feed;
    } else{
        shareFeed = feed;
    }
    self.feed = feed;
    NSArray *imageModels = [shareFeed image_urls].array;
    UMComImageUrl *imageModel = nil;
    if (imageModels.count > 0) {
        imageModel = [[shareFeed image_urls] firstObject];
    }
    NSString *imageUrl = imageModel.small_url_string;//[[shareFeed.images firstObject] valueForKey:@"360"];
    
    //取转发的feed才有链接
    NSString *urlString = self.feed.share_link;
    urlString = [NSString stringWithFormat:@"%@?ak=%@&platform=%@",urlString,[UMComSession sharedInstance].appkey,platformName];
    [UMSocialData defaultData].extConfig.qqData.url = urlString;
    [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;
    
    NSString *shareText = [NSString stringWithFormat:@"%@ %@",shareFeed.text,urlString];
    if (shareFeed.text.length > MaxShareLength+2 - MaxLinkLength) {
        NSString *feedString = [shareFeed.text substringToIndex:MaxShareLength - MaxLinkLength];
        shareText = [NSString stringWithFormat:@"%@…… %@",feedString,urlString];
    }
    [UMSocialData defaultData].extConfig.sinaData.shareText = shareText;
    
    NSString *title = shareFeed.title;
    if (title.length == 0) {
        title = shareText;
    }
    [UMSocialData defaultData].title = title;
    
    UIImage *shareImage = nil;
    if (imageUrl) {
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:imageUrl];
    } else{
        shareImage = [UIImage imageNamed:@"icon"];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault];
    }
    
    [[UMSocialControllerService defaultControllerService] setShareText:shareFeed.text shareImage:shareImage socialUIDelegate:(id)self];
    
    UMSocialSnsPlatform *socialPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    socialPlatform.snsClickHandler(viewControlller,[UMSocialControllerService defaultControllerService],YES);
}

- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSString *platform = [[response.data allKeys] objectAtIndex:0];
        [UMComPushRequest postShareStaticsWithPlatformName:platform feed:self.feed completion:^(NSError *error) {
            
        }];
    }
}

- (BOOL)isWechatInstalled
{
    return ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]);
}


@end
