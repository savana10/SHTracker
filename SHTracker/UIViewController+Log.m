//
//  UIViewController+Log.m
//  SHTracker
//
//  Created by Savana on 25/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+Log.h"
#import "SHLogger.h"
#import "SHLogSenderVC.h"

@implementation UIViewController (Log)
UITapGestureRecognizer *threeTap;
+ (void)load
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzleSelector = @selector(sh_viewWillAppear:);
        [self addSwizzleMethodsBetween:originalSelector And:swizzleSelector];
        
        SEL originalLoad = @selector(viewWillDisappear:);
        SEL swizzleLoad = @selector(sh_viewWillDisappear:);
        [self addSwizzleMethodsBetween:originalLoad And:swizzleLoad];
    });
    
}
+(void) addSwizzleMethodsBetween:(SEL) originalSelector And:(SEL) swizzleSelector
{
    Class class =  [self class];
    Method originalMethod =  class_getInstanceMethod(class, originalSelector);
    Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);
    BOOL methodAdded = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    if (methodAdded) {
        class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }

}
#pragma mark - Swizzle Method
#pragma mark  viewWillAppear
- (void) sh_viewWillAppear:(BOOL)animated
{
    if ([[NSString stringWithFormat:@"%s",class_getName([self class])] isEqualToString:@"SHLogSenderVC"]) {
        return;
    }
    NSMutableDictionary * classDetails = [NSMutableDictionary new];
    [classDetails setObject:@"UIViewController" forKey:@"type"];
    [classDetails setObject:[NSString stringWithFormat:@"%s",class_getName([self class])] forKey:@"className"];
    [[SHLogger logger]  log:classDetails];
    threeTap = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(giveSendMailOptions)];
    int t = 3;
    if ([[SHLogger logger] noOfTaps]) {
        t = [[SHLogger logger]  noOfTaps];
        if (t <= 2) {
            t = 3;
        }
    }
    [threeTap setNumberOfTapsRequired:t];
    [self.view setUserInteractionEnabled:true];
    [self.view addGestureRecognizer:threeTap];
}
#pragma mark  viewWillDisappear
- (void) sh_viewWillDisappear:(BOOL)animated
{
    if ([[NSString stringWithFormat:@"%s",class_getName([self class])] isEqualToString:@"SHLogSenderVC"]) {
        return;
    }
    [self.view removeGestureRecognizer:threeTap];
}
#pragma mark - Tap Gesture Selector
-(void) giveSendMailOptions
{
    SHLogSenderVC *vc = [[SHLogSenderVC alloc]  init];
    [self presentViewController:vc animated:true completion:nil];
}

@end
