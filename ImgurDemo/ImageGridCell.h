//
//  ImageGridCell.h
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "PSTCollectionView.h"

@interface ImageGridCell : PSUICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
