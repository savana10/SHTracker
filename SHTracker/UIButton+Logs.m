//
//  UIButton+Logs.m
//  SHTracker
//
//  Created by Savana on 25/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "UIButton+Logs.h"
#import "SHLogger.h"
@implementation UIButton (Logs)
/**
 *  To know when a touch on UIButton has ended , currently supportng only UIControlEventTouchUpInside.
 *  If a UIButton sub classed then only methods with following method signature is logged
 
    -(void) customButtinActionName:(UIButton *) sender 
                        or 
    -(IBAction ) customButtonAction:(UIButton *) sender
 *
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    for (id target in self.allTargets) {
        NSArray *actions = [self actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
        NSMutableDictionary * classDetails = [NSMutableDictionary new];
        [classDetails setObject:@"UIButton" forKey:@"type"];
        for (NSString *action in actions) {
            [classDetails setObject:action forKey:@"buttonAction"];
        }
        [[SHLogger logger]  log:classDetails];
    }
}



@end
