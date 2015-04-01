//
//  FilterViewController.h
//  ImgurDemo
//
//  Created by Ray Vo on 1/4/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate;

@interface FilterViewController : UITableViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate>delegate;
@property (nonatomic, strong) NSMutableDictionary *filterOptions;

@end

@protocol FilterViewControllerDelegate <NSObject>
@required
- (void)filterViewController:(FilterViewController *)vc filterOptionsChanged:(NSMutableDictionary *)filterOptions;
@end
