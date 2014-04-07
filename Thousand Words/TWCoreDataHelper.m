//
//  TWCoreDataHelper.m
//  Thousand Words
//
//  Created by David Blanck on 3/30/14.
//  Copyright (c) 2014 VidWare. All rights reserved.
//

#import "TWCoreDataHelper.h"

@implementation TWCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]){  //testing delegate responds to manageObjectContext
        context = [delegate managedObjectContext];
    }
    
    return context;
}


@end
