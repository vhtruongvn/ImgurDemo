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
// gallery/{section}/{sort}/{page}.json
// gallery/{section}/{sort}/{window}/{page}?showViral={bool}
static NSString * const APIMainGalleryURLString = @"3/gallery";

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

- (void)getMainGalleryWithFilter:(NSString *)section sort:(NSString *)sort window:(NSString *)window page:(NSString *)page showViral:(NSString *)showViral
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:APIMainGalleryURLString];
    [urlString appendString:[NSString stringWithFormat:@"/%@", section]];
    [urlString appendString:[NSString stringWithFormat:@"/%@", sort]];
    if ([section isEqualToString:@"top"]) {
        [urlString appendString:[NSString stringWithFormat:@"/%@", window]];
    }
    [urlString appendString:[NSString stringWithFormat:@"/%@", page]];
    if ([section isEqualToString:@"user"]) {
        [urlString appendString:[NSString stringWithFormat:@"?showViral=%@", showViral]];
    }
    
    NSLog(@"%@", urlString);
    
    [self GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(apiClient:didReceiveData:fromSelector:)])
        {
            [self.delegate apiClient:self didReceiveData:responseObject fromSelector:@selector(getMainGalleryWithFilter:sort:window:page:showViral:)];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(apiClient:didFailWithError:fromSelector:)])
        {
            [self.delegate apiClient:self didFailWithError:error fromSelector:@selector(getMainGalleryWithFilter:sort:window:page:showViral:)];
        }
    }];
}

@end
