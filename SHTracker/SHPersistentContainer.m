//
//  SHPersistentContainer.m
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "SHPersistentContainer.h"

#define SHDirectory @"UserLogs"

@implementation SHPersistentContainer
#pragma mark - Singleton
+(SHPersistentContainer *) sharedInstance
{
    static dispatch_once_t container;
    static SHPersistentContainer *persistence;
    
    dispatch_once(&container, ^{
        persistence = [[self alloc]  init];
    });
    
    return persistence;
}
#pragma mark- Initializer
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark - Directory
#pragma mark Path
-(NSString *) filesPersistentDirectory
{
    NSString *library = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *pd = [library stringByAppendingPathComponent:@"Private Documents"];
    return [pd stringByAppendingPathComponent:SHDirectory];
}
#pragma mark  Create
-(void) createDirectoryIfNeeded
{
    NSError *error = nil;
    [[NSFileManager defaultManager]  createDirectoryAtPath:[self filesPersistentDirectory] withIntermediateDirectories:YES attributes:NULL error:&error];
    if (error) {
        NSLog(@"error while create directory due to %@",error.description);
    }
}

@end
