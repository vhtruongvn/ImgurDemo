//
//  ImgurAPIClient.m
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "ImgurAPIClient.h"

/* Showtimes API */
static NSString * const APIURLString = @"https://api.imgur.com/";

static NSString * const APIAuthorizationURLString = @"oauth2/authorize";

/**
 *
 Parameters
 Key        Required	Value
 section	optional	hot | top | user - defaults to hot
 sort       optional	viral | top | time | rising (only available with user section) - defaults to viral
 page       optional	integer - the data paging number
 window     optional	Change the date range of the request if the section is "top", day | week | month | year | all, defaults to day
 showViral	optional	true | false - Show or hide viral images from the 'user' section. Defaults to true
 */
// gallery/{section}/{sort}/{page}?showViral=bool
static NSString * const APIMainGalleryFilterURLString = @"3/gallery/%@/viral/%@?showViral=%@";

@implementation ImgurAPIClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.requestSerializer setValue:@"Client-ID 8e29368e29ab65f" forHTTPHeaderField:@"Authorization"];
        
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    
    return self;
}

+ (ImgurAPIClient *)sharedAPIClient
{
    static ImgurAPIClient *_sharedAPIClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPIClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:APIURLString]];
    });
    
    return _sharedAPIClient;
}

#pragma mark - Gallery API

- (void)getMainGalleryWithFilter:(NSString *)section page:(NSString *)page showViral:(NSString *)showViral
{
    NSString *urlString = [NSString stringWithFormat:APIMainGalleryFilterURLString, section, page, showViral];
    
    [self GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(apiClient:didReceiveData:fromSelector:)])
        {
            [self.delegate apiClient:self didReceiveData:responseObject fromSelector:@selector(getMainGalleryWithFilter:page:showViral:)];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(apiClient:didFailWithError:fromSelector:)])
        {
            [self.delegate apiClient:self didFailWithError:error fromSelector:@selector(getMainGalleryWithFilter:page:showViral:)];
        }
    }];
}

@end
