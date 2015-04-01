//
//  AboutViewController.m
//  ImgurDemo
//
//  Created by Ray Vo on 1/4/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@property (nonatomic, weak) IBOutlet UITableViewCell *versionCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *buildCell;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    
    NSString *versionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    self.versionCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", versionString];
    self.buildCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", buildString];
}

@end
