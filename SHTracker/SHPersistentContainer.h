//
//  SHPersistentContainer.h
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHPersistentContainer : NSObject
+(SHPersistentContainer *) sharedInstance;
//! Directory Path
-(NSString *) filesPersistentDirectory;
/**
 *  Check If Directory exists at filePeristentDirectory path , if doesn't exist then create a new empty directory at that path.
 */
-(void) createDirectoryIfNeeded;

@end
