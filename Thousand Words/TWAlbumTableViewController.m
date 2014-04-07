//
//  TWAlbumTableViewController.m
//  Thousand Words
//
//  Created by David Blanck on 3/30/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import "TWAlbumTableViewController.h"
#import "Album.h"
#import "TWCoreDataHelper.h"
#import "TWPhotosCollectionViewController.h"

@interface TWAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation TWAlbumTableViewController

-(NSMutableArray *)albums
{
    if (!_albums) _albums = [[NSMutableArray alloc]init];  // lazy instantiation (will alway be available)
    return _albums;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];   // call Super on viewWillAppear method
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];   //used as a search criteria
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    //    id delegate = [[UIApplication sharedApplication] delegate];   // get access to delegate
    //    NSManagedObjectContext *context = [delegate managedObjectContext];
    
    
    NSError *error = nil;
    
    NSArray *fetchedAlbums = [[TWCoreDataHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];  //executes fetch request
    
    self.albums = [fetchedAlbums mutableCopy];  //set the value to a mutable copy of the array
    
    [self.tableView reloadData];   //reload table
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)addAlbumbarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc]initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
    
    
}

#pragma mark - Helper Methods
-(Album *)albumWithName:(NSString *)name
{
    //    id delegate = [[UIApplication sharedApplication] delegate];             //  getting app delegate
    NSManagedObjectContext *context = [TWCoreDataHelper managedObjectContext];     //  managedObjectContext allow us to interact with and query data
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];  //NSENtityDescription is required to save core data
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    if (![context save:&error]){       // save data, &error is a pointer to a pointer to an error object
        //we have an error
        NSLog(@"%@", error);
    }
    return album;
}


#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)  //button at index 1 (in case you add other buttons later)
    {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.albums addObject:[self albumWithName:alertText]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.albums count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"Album Chosen"])
    {
        if ([segue.destinationViewController isKindOfClass:[TWPhotosCollectionViewController class]])
        {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            
            TWPhotosCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.album = self.albums[path.row];
        }
    }
    
    
    
}


@end
