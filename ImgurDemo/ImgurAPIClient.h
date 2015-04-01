//
//  ImgurAPIClient.h
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol ImgurAPIClientDelegate;

@interface ImgurAPIClient : AFHTTPSessionManager

@property (nonatomic, weak) id<ImgurAPIClientDelegate>delegate;

- (instancetype)initWithBaseURL:(NSURL *)url;

+ (ImgurAPIClient *)sharedAPIClient;
- (void)getMainGalleryWithFilter:(NSString *)section sort:(NSString *)sort window:(NSString *)window page:(NSString *)page showViral:(NSString *)showViral;

@end

@protocol ImgurAPIClientDelegate <NSObject>
@optional
- (void)apiClient:(ImgurAPIClient *)client didReceiveData:(id)response fromSelector:(SEL)selector;
- (void)apiClient:(ImgurAPIClient *)client didFailWithError:(NSError *)error fromSelector:(SEL)selector;
@end
