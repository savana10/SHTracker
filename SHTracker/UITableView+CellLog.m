//
//  UITableView+CellLog.m
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "UITableView+CellLog.h"
#import <objc/runtime.h>
#import "SHLogger.h"
@implementation UITableView (CellLog)
id object;
+(void) load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        object = [[self alloc]  init];
        [[NSNotificationCenter defaultCenter]  addObserver:object selector:@selector(changeInTV:) name:UITableViewSelectionDidChangeNotification object:nil];
    });

}
#pragma mark - NSNotificationObserver

-(void) changeInTV:(NSNotification *)object
{
    
    if ([object.object isKindOfClass:[UITableView class]]) {
        UITableView *T = object.object;
        NSMutableDictionary *details = [NSMutableDictionary new];
        [details setObject:@"UITableView" forKey:@"type"];
        NSMutableArray *ar = [NSMutableArray new];
        for (NSIndexPath *indexPath in [T indexPathsForSelectedRows]) {
            [ar addObject:@{@"section":[NSNumber numberWithLong:indexPath.section],@"row":[NSNumber numberWithLong:indexPath.row]}];
        }
        [details setObject:ar forKey:@"selectedRows"];
        NSString *ds = (NSString *)T.dataSource;
        if (ds.description) {
            if ([ds.description containsString:@":"]) {
                NSRange r = [ds.description rangeOfString:@":"];
                NSString *dsName = [ds.description substringWithRange:NSMakeRange(1, r.location-1)];
                [details setObject:dsName forKey:@"DataSource"];
            }
        }
        NSString *sd = (NSString *)T.delegate;
        if (sd.description) {
            if ([sd.description containsString:@":"]) {
                NSRange r = [sd.description rangeOfString:@":"];
                NSString *dsName = [sd.description substringWithRange:NSMakeRange(1, r.location-1)];
                [details setObject:dsName forKey:@"Delegate"];
            }
        }
        [[SHLogger logger]  log:details];
    }
    
}
@end
