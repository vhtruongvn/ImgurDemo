//
//  ImageGridCell.m
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import "ImageGridCell.h"

static UIEdgeInsets contentInsets = { .top = 6, .left = 6, .right = 6, .bottom = 0 };
static CGFloat subTitleLabelHeight = 24;

@implementation ImageGridCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor darkGrayColor];
        self.selectedBackgroundView = background;
        
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        _image.layer.borderWidth = 0.5f;
        _image.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_image];
        [self.contentView addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat imageHeight = CGRectGetHeight(self.bounds) - contentInsets.top - subTitleLabelHeight - contentInsets.bottom;
    CGFloat imageWidth = CGRectGetWidth(self.bounds) - contentInsets.left - contentInsets.right;
    
    _image.frame = CGRectMake(contentInsets.left, contentInsets.top, imageWidth, imageHeight);
    _label.frame = CGRectMake(contentInsets.left, CGRectGetMaxY(_image.frame), imageWidth, subTitleLabelHeight);
}

- (void)setHighlighted:(BOOL)highlighted {
    if (highlighted) {
        _label.backgroundColor = [UIColor yellowColor];
    }
    else {
        _label.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
