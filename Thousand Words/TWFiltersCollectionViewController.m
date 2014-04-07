//
//  TWFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by David Blanck on 4/6/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import "TWFiltersCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"

@interface TWFiltersCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;


@end

@implementation TWFiltersCollectionViewController

-(NSMutableArray *)filters;
{
    if (!_filters) _filters = [[NSMutableArray alloc]init];
    
    return _filters;
}

-(CIContext *)context;
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    
    return _context;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filters = [[[self class]photoFilters]mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helpler

+(NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2],nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    //CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:nil];
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer  = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues:nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:nil];
    
    NSArray *allFilters = @[sepia,blur,colorClamp,instant,noir,colorControls,transfer,unsharpen,monochrome];
    
    return allFilters;
}

-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    CIImage *unfilteredImage = [[CIImage alloc]initWithCGImage:image.CGImage];   // get CIIMage from UIImage
    
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];                  //setup filter
    CIImage *filteredImage = [filter outputImage];                              // get filtered image back
    
    CGRect extent = [filteredImage extent];                                     // get a rect to see how big the image will be
    
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];  //
    
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    //NSLog(@"look at all of this data %@", UIImagePNGRepresentation(finalImage));
    return finalImage;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);  //created a queue and used a "C" function
    
    //push queue on another thread
    dispatch_async(filterQueue, ^{
        UIImage *filterImage = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImage;  // UI changes on mail thread only
        });
    });
    
    //cell.imageView.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]]; (in grand central dispatch now - above)
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TWPhotoCollectionViewCell *selectedCell = (TWPhotoCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    self.photo.image = selectedCell.imageView.image;   // casting is as a (TWPhotoCollectionViewCell *) is a "cast", cast it so we can acess the image
    
    //check if an image is available
    if (self.photo.image){
        
        NSError *error = nil;
        
        if (![[self.photo managedObjectContext] save:&error])
        {
            //handle error
            NSLog(@"%@",error);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}





@end
