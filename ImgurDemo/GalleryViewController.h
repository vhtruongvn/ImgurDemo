//
//  GalleryViewController.h
//  ImgurDemo
//
//  Created by Ray Vo on 31/3/15.
//  Copyright (c) 2015 Truong Vo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionView.h"

@interface GalleryViewController : UIViewController <PSTCollectionViewDataSource, PSTCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end
