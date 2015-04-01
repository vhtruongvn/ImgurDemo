//
//  GalleryViewController.m
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "AppDelegate.h"
#import "GalleryViewController.h"
#import "FilterViewController.h"
#import "ImageGridCell.h"
#import "ImgurAPIClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const ImageGridCellIdentifier = @"ImageGridCell";

@interface GalleryViewController () <UIScrollViewDelegate, ImgurAPIClientDelegate, FilterViewControllerDelegate> {
    CGSize imageGridCellSize;
    NSMutableDictionary *_filterOptions;
    UIView *_imageContainer;
}

@property (nonatomic, weak) IBOutlet PSUICollectionView *gridView;
@property (nonatomic, weak) IBOutlet UISegmentedControl *layoutSegmentedControl;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) NSMutableArray *galleries;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configGridView];
    
    _refreshButton.layer.borderWidth = 2.0f;
    _refreshButton.layer.cornerRadius = 5;
    _refreshButton.layer.borderColor = [[UIColor blackColor] CGColor];
    [_refreshButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _refreshButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    // Init Filter Options
    _filterOptions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      @"hot", @"section",
                      @"true", @"showViral",
                      nil];
    
    // Start loading galleries
    [self loadMainGallery];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Public



#pragma mark - Private

- (void)configGridView {
    int cellFullWidth = CGRectGetWidth(self.view.frame);
    imageGridCellSize = CGSizeMake(cellFullWidth, 180);
    
    PSUICollectionViewFlowLayout *layout = [[PSUICollectionViewFlowLayout alloc] init];
    _gridView.collectionViewLayout = layout;
    _gridView.delegate = self;
    _gridView.dataSource = self;
    _gridView.alwaysBounceVertical = YES;
    _gridView.backgroundColor = [UIColor whiteColor];
    [_gridView registerClass:[ImageGridCell class] forCellWithReuseIdentifier:ImageGridCellIdentifier];
}

- (void)loadMainGallery {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ImgurAPIClient *client = [ImgurAPIClient sharedAPIClient];
    client.delegate = self;
    [client getMainGalleryWithFilter:_filterOptions[@"section"] page:@"0" showViral:_filterOptions[@"showViral"]];
}

#pragma mark - IBActions

- (IBAction)layoutChanged:(id)sender {
    switch (self.layoutSegmentedControl.selectedSegmentIndex) {
        case 0:
        {
            int cellFullWidth = CGRectGetWidth(self.view.frame);
            imageGridCellSize = CGSizeMake(cellFullWidth, 180);
            break;
        }
        case 1:
        {
            int cellFullWidth = CGRectGetWidth(self.view.frame) / 2 - 10;
            imageGridCellSize = CGSizeMake(cellFullWidth, 180);
            break;
        }
    
        default:
            break;
    }
    
    [self.gridView reloadData];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self loadMainGallery];
}

- (IBAction)closeButtonPressed:(id)sender {
    [_imageContainer removeFromSuperview];
}

#pragma mark - APIClientDelegate

- (void)apiClient:(ImgurAPIClient *)client didReceiveData:(id)response fromSelector:(SEL)selector {
    NSLog(@"%@:\n%@", NSStringFromSelector(selector), response);
    
    // End the refreshing
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    if (selector == @selector(getMainGalleryWithFilter:page:showViral:)) {
        if (_galleries == nil) {
            self.galleries = [[NSMutableArray alloc] init];
        }
        
        [_galleries removeAllObjects];
        [_galleries addObjectsFromArray:[response objectForKey:@"data"]];
        
        // Reload table data
        [self.gridView reloadData];
    }
}

- (void)apiClient:(ImgurAPIClient *)client didFailWithError:(NSError *)error fromSelector:(SEL)selector {
    NSLog(@"%@:\n%@", NSStringFromSelector(selector), [NSString stringWithFormat:@"%@", error]);
    
    // End the refreshing
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                        message:[NSString stringWithFormat:@"%@", [error localizedDescription]]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - FilterViewControllerDelegate

- (void)filterViewController:(FilterViewController *)vc filterOptionsChanged:(NSMutableDictionary *)filterOptions {
    NSLog(@"%@", filterOptions);
    
    _filterOptions = filterOptions;
    
    [self loadMainGallery];
}

#pragma mark - PSTCollectionViewDataSource

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageGridCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *galleryItem = [_galleries objectAtIndex:indexPath.row];
    
    cell.label.text = [NSString stringWithFormat:@"%@", [galleryItem objectForKey:@"title"]];
    
    NSString *imageToLoad = [NSString stringWithFormat:@"%@", [galleryItem objectForKey:@"link"]];
    if ([imageToLoad length] > 0) {
        [cell.image setImageWithURL:[NSURL URLWithString:imageToLoad] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    } else {
        cell.image.image = [UIImage imageNamed:@"placeholder"];
    }
    
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return imageGridCellSize;
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_galleries count];
}

#pragma mark - PSTCollectionViewDelegate

- (void)collectionView:(PSTCollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(PSTCollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#define ImageTag 100
#define LabelTag 101

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *galleryItem = [_galleries objectAtIndex:indexPath.row];
    NSString *type = [galleryItem objectForKey:@"type"];
    if ([type isKindOfClass:[NSString class]]
        && [type containsString:@"image"]) {
        if (_imageContainer == nil) {
            _imageContainer = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            _imageContainer.backgroundColor = [UIColor lightGrayColor];
            _imageContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            // Image View
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:_imageContainer.frame];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.tag = ImageTag;
            [_imageContainer addSubview:imageView];
            NSString *imageToLoad = [NSString stringWithFormat:@"%@", [galleryItem objectForKey:@"link"]];
            if ([imageToLoad length] > 0) {
                [imageView setImageWithURL:[NSURL URLWithString:imageToLoad] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            } else {
                imageView.image = [UIImage imageNamed:@"placeholder"];
            }
            
            // Button to hide _imageContainer
            int buttonWidth = 80;
            int buttonHeight = 40;
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(CGRectGetWidth(_imageContainer.frame) - buttonWidth - 20, 30, buttonWidth, buttonHeight);
            closeButton.layer.borderWidth = 2.0f;
            closeButton.layer.borderColor = [[UIColor whiteColor] CGColor];
            closeButton.layer.cornerRadius = 5;
            closeButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
            [closeButton setTitle:@"Close" forState:UIControlStateNormal];
            [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            closeButton.translatesAutoresizingMaskIntoConstraints = NO;
            [_imageContainer addSubview:closeButton];
            
            NSDictionary *viewsDictionary = @{
                                              @"_imageContainer": _imageContainer,
                                              @"imageView": imageView,
                                              @"closeButton": closeButton
                                              };
            
            NSArray *imageView_Constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:viewsDictionary];
            NSArray *imageView_Constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                                          options:0
                                                                                          metrics:nil
                                                                                            views:viewsDictionary];
            NSArray *closeBtn_Constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[closeButton(40)]"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:viewsDictionary];
            NSArray *closeBtn_Constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[closeButton(100)]-20-|"
                                                                                         options:0
                                                                                         metrics:nil
                                                                                           views:viewsDictionary];
            
            [_imageContainer addConstraints:imageView_Constraint_POS_V];
            [_imageContainer addConstraints:imageView_Constraint_POS_H];
            [_imageContainer addConstraints:closeBtn_Constraint_POS_V];
            [_imageContainer addConstraints:closeBtn_Constraint_POS_H];
        } else {
            UIImageView *imageView = (UIImageView *)[_imageContainer viewWithTag:ImageTag];
            NSString *imageToLoad = [NSString stringWithFormat:@"%@", [galleryItem objectForKey:@"link"]];
            if ([imageToLoad length] > 0) {
                [imageView setImageWithURL:[NSURL URLWithString:imageToLoad] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            } else {
                imageView.image = [UIImage imageNamed:@"placeholder"];
            }
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [UIView transitionWithView:appDelegate.window
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            [appDelegate.window addSubview:_imageContainer];
                            
                            NSDictionary *viewsDictionary = @{ @"_imageContainer": _imageContainer };
                            NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageContainer]-0-|"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:viewsDictionary];
                            NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageContainer]-0-|"
                                                                                                options:0
                                                                                                metrics:nil
                                                                                                  views:viewsDictionary];
                            [appDelegate.window addConstraints:constraint_POS_V];
                            [appDelegate.window addConstraints:constraint_POS_H];
                        } completion:nil];
    }
}

- (void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue destinationViewController] isKindOfClass:[FilterViewController class]]) {
        FilterViewController *filterViewController = (FilterViewController *)[segue destinationViewController];
        filterViewController.delegate = self;
        filterViewController.filterOptions = _filterOptions;
    }
}

@end
