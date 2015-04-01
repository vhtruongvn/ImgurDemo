//
//  FilterViewController.m
//  ImgurDemo
//
//  Created by Ray Vo on 1/4/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "FilterViewController.h"

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Filter Options";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed:)];
}

#pragma mark - IBActions

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(filterViewController:filterOptionsChanged:)]) {
        [self.delegate filterViewController:self filterOptionsChanged:_filterOptions];
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if ([cell.textLabel.text isEqualToString:_filterOptions[@"section"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 1) {
        if ([cell.textLabel.text isEqualToString:_filterOptions[@"sort"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else if (indexPath.section == 2) {
        if ([cell.textLabel.text isEqualToString:_filterOptions[@"window"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        if ([cell.textLabel.text isEqualToString:_filterOptions[@"showViral"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                [_filterOptions setValue:@"hot" forKey:@"section"];
                break;
            }
            case 1:
            {
                [_filterOptions setValue:@"top" forKey:@"section"];
                break;
            }
            case 2:
            {
                [_filterOptions setValue:@"user" forKey:@"section"];
                break;
            }
                
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [_filterOptions setValue:@"viral" forKey:@"sort"];
                break;
            }
            case 1:
            {
                [_filterOptions setValue:@"top" forKey:@"sort"];
                break;
            }
            case 2:
            {
                [_filterOptions setValue:@"time" forKey:@"sort"];
                break;
            }
            case 3:
            {
                [_filterOptions setValue:@"rising" forKey:@"sort"];
                break;
            }
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
            {
                [_filterOptions setValue:@"day" forKey:@"window"];
                break;
            }
            case 1:
            {
                [_filterOptions setValue:@"week" forKey:@"window"];
                break;
            }
            case 2:
            {
                [_filterOptions setValue:@"month" forKey:@"window"];
                break;
            }
            case 3:
            {
                [_filterOptions setValue:@"year" forKey:@"window"];
                break;
            }
            case 4:
            {
                [_filterOptions setValue:@"all" forKey:@"window"];
                break;
            }
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                [_filterOptions setValue:@"true" forKey:@"showViral"];
                break;
            }
            case 1:
            {
                [_filterOptions setValue:@"false" forKey:@"showViral"];
                break;
            }
                
            default:
                break;
        }
    }
    
    if ([_filterOptions[@"section"] isEqualToString:@"top"]) {
        if (!_filterOptions[@"window"]) {
            [_filterOptions setValue:@"day" forKey:@"window"]; // defaults to day
        }
    } else {
        [_filterOptions removeObjectForKey:@"window"];
    }
    
    if ([_filterOptions[@"section"] isEqualToString:@"user"]) {
        if (!_filterOptions[@"showViral"]) {
            [_filterOptions setValue:@"true" forKey:@"showViral"]; // defaults to true
        }
    } else {
        [_filterOptions removeObjectForKey:@"showViral"];
        if ([_filterOptions[@"sort"] isEqualToString:@"rising"]) { // only available with user section
            [_filterOptions setValue:@"viral" forKey:@"sort"]; // defaults to viral
        }
    }
    
    NSLog(@"%@", _filterOptions);
    
    [self.tableView reloadData];
}

@end
