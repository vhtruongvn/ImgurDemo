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
    
    [self.tableView reloadData];
}

@end
