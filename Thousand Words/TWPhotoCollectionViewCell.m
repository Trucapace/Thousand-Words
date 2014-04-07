//
//  TWPhotoCollectionViewCell.m
//  Thousand Words
//
//  Created by David Blanck on 3/30/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import "TWPhotoCollectionViewCell.h"
#define IMAGEVIEW_BORDER_LENGTH 5

@implementation TWPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder   //called by storyboard
{
    self = [super initWithCoder:(NSCoder *)aDecoder];
    
    if (self){
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];   //have the same center point
    [self.contentView addSubview:self.imageView];  //view for the cell where we can add items onto
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
