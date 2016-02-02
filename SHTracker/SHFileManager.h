//
//  SHFileManager.h
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHFileManager : NSObject
+(SHFileManager *) fileManager;
//! Current File path
-(NSString *) currentSessionPath;
//! Save the dictionary locally
-(void) writeLogToCurrentFile:(NSDictionary *) value;
//! Delete all files , this will delete all files except the current file
-(void) deleteAllSavedFiles;
/**
 *  Fetch list of files based on the given option
 *
 *  @param options value for retrieving files 0 - Current , 1 - Last , 2 - All
 *
 *  @return Array of file paths String type
 */
-(NSArray *) fetchLogFileWith:(int) options;
@end
