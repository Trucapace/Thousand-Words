//
//  TWPhotoDetailViewController.h
//  Thousand Words
//
//  Created by David Blanck on 4/6/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo; //get access to class "forward declaration"

@interface TWPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)addFilterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;

@end
