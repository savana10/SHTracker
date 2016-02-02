//
//  SHFileManager.m
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "SHFileManager.h"
#import "SHPersistentContainer.h"
@interface SHFileManager ()
@property (strong,nonatomic) NSString *fileName;
@property (strong,nonatomic) NSMutableArray *sessionArray;
@end

@implementation SHFileManager
static NSDateFormatter *dateFormat;

#pragma mark - Singleton

+(SHFileManager *) fileManager
{
    static SHFileManager *manager;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        manager =[[self alloc] init];
    });
    return manager;
    
}
#pragma  mark - Initializer
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDateFormatter *dtf = [NSDateFormatter new];
        [dtf setDateFormat:@"dd_MM_yy_HH_mm_ss"];
        self.fileName = [dtf stringFromDate:[NSDate date]];
        self.sessionArray = [NSMutableArray new];
        dateFormat =[NSDateFormatter new];
        [dateFormat setDateFormat:@"HH_mm_ss"];
        [self writeArrayToFile];
        
    }
    return self;
}
#pragma mark - Current Path
- (NSString *)currentSessionPath
{
    NSString *s = [[SHPersistentContainer sharedInstance]  filesPersistentDirectory];
    s = [s stringByAppendingPathComponent:self.fileName];
    return s;
}
#pragma mark - Save
-(void) writeLogToCurrentFile:(NSDictionary *) value
{
    @synchronized(self.sessionArray){
        NSMutableDictionary *dt = [[NSMutableDictionary alloc]  initWithDictionary:value];
        [dt setObject:[dateFormat stringFromDate:[NSDate date]] forKey:@"loggedTime"];
        dt = [NSMutableDictionary dictionaryWithDictionary:[self removeNullInDictionary:dt]];
        [self.sessionArray addObject:dt];
        [self writeArrayToFile];
    }
    
    
}
#pragma mark Check for NULL
-(NSDictionary *) removeNullInDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *d =[NSMutableDictionary new];
    for (NSString *key in [dict allKeys]) {
        if ([[dict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            [d setObject:[self removeNullInDictionary:[dict objectForKey:key]] forKey:key];
        }else if([[dict objectForKey:key] isKindOfClass:[NSArray class]]){
            [d setObject:[self removeNullInArray:[dict objectForKey:key]] forKey:key];
        }else if(![[dict objectForKey:key] isKindOfClass:[NSNull class]]){
            [d setObject:[dict objectForKey:key] forKey:key];
        }
    }
    return d;
}
-(NSArray *) removeNullInArray:(NSArray *)array
{
    NSMutableArray *a = [NSMutableArray new];
    for (id ob in array) {
        if ([ob isKindOfClass:[NSDictionary class]]) {
            [a addObject:[self removeNullInDictionary:ob]];
        }else if([ob isKindOfClass:[NSArray class]]){
            [a addObject:[self removeNullInArray:ob]];
        }else if(ob != NULL){
            [a addObject:ob];
        }
    }
    return a;
}
#pragma mark - Check Session
-(BOOL) sessionFileExists
{
    return [[NSFileManager defaultManager]  fileExistsAtPath:[self currentSessionPath]];
}
#pragma mark - File Options
-(void) writeArrayToFile
{
    [[SHPersistentContainer sharedInstance]  createDirectoryIfNeeded];
    if(![self.sessionArray writeToFile:[self currentSessionPath] atomically:true]){
        NSLog(@"Unable to write file");
    }
}
-(void) deleteAllSavedFiles
{
    NSError *error;
    NSArray *array = [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:[[SHPersistentContainer sharedInstance] filesPersistentDirectory] error:&error];
    if (error == nil) {
        for (NSString *s in array) {
            if ([s isEqualToString:self.fileName]) {
                return;
            }
            NSString *t = [[[SHPersistentContainer sharedInstance] filesPersistentDirectory]  stringByAppendingPathComponent:s];
            if ([[NSFileManager defaultManager] isDeletableFileAtPath:t]) {
                [[NSFileManager defaultManager] removeItemAtPath:t error:&error];
            }
        }
    }
}
#pragma mark - Fetch File Path
- (NSArray *)fetchLogFileWith:(int)options
{
    
    NSMutableArray *filesPath = [NSMutableArray new];
    NSError *error = nil;
    NSArray *array = [[NSFileManager defaultManager]  contentsOfDirectoryAtPath:[[SHPersistentContainer sharedInstance] filesPersistentDirectory] error:&error];
    if (array.count > 0) {
        if (options == 2) {
            for (NSString * s in array) {
                NSString *filePath = [[[SHPersistentContainer sharedInstance] filesPersistentDirectory] stringByAppendingPathComponent:s];
                [filesPath addObject:filePath];
            }
        }else{
            int currentIndex = (int)[array indexOfObject:self.fileName];
            if (options == 0) {
                [filesPath addObject:[[[SHPersistentContainer sharedInstance] filesPersistentDirectory] stringByAppendingPathComponent:array[currentIndex]]];
            }else if (options == 1){
                currentIndex= currentIndex -1;
                if (currentIndex >= 0 && currentIndex < array.count ) {
                    [filesPath addObject:[[[SHPersistentContainer sharedInstance] filesPersistentDirectory] stringByAppendingPathComponent:array[currentIndex]]];
                }
                
            }
        }
    }
    
    return filesPath;
}
@end
