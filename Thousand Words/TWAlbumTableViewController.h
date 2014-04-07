//
//  TWAlbumTableViewController.h
//  Thousand Words
//
//  Created by David Blanck on 3/30/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWAlbumTableViewController : UITableViewController 

@property (strong, nonatomic) NSMutableArray *albums;

- (IBAction)addAlbumbarButtonItemPressed:(UIBarButtonItem *)sender;

@end
