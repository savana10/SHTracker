//
//  SHLogger.m
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "SHLogger.h"
#import "SHFileManager.h"


@interface SHLogger()
@property (strong,nonatomic) SHFileManager *fileManger;
@end

@implementation SHLogger

+(SHLogger *) logger
{
    static dispatch_once_t once;
    static SHLogger *logger;
    dispatch_once(&once, ^{
        logger = [[self alloc]  init];
    });
    return logger;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [SHFileManager fileManager];
        NSLog(@"file path of current session %@",[[SHFileManager fileManager] currentSessionPath]);
    }
    return self;
}
-(void)  log:(NSDictionary *) details
{
    [[SHFileManager fileManager]  writeLogToCurrentFile:details];
}
@end
