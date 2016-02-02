//
//  ViewController.m
//  SHTracker
//
//  Created by Savana on 25/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "ViewController.h"
#import "SHFileManager.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)ss:(UIButton *)b {

//    NSLog(@"can oer %i",[self canPerformAction:@selector(ss:) withSender:nil]);
//
//    for (id target in b.allTargets) {
//        
//        NSArray *actions = [b actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
//        for (NSString *action in actions) {
//            NSLog(@"action %@",action);
////            SEL originalSelector = NSSelectorFromString(action);
////            //                [newButton addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
////            SEL swizzlerSelector = @selector(own_Inside:);
////            Method originalMethod = class_getInstanceMethod(class, originalSelector);
////            Method swizzlerMethod = class_getInstanceMethod(class, swizzlerSelector);
////            BOOL added = class_addMethod(class, originalSelector, method_getImplementation(swizzlerMethod), method_getTypeEncoding(swizzlerMethod));
////            if (added) {
////                class_replaceMethod(class, swizzlerSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
////            }else{
////                method_exchangeImplementations(originalMethod, swizzlerMethod);
////            }
////            
//            
//        }
//    }
}
- (IBAction)ag:(id)sender {
}

- (IBAction)as:(UIButton*)sender {
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ask"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ask"];
    }
    [cell.textLabel setText:@"123"];
    UIView *v = [[UIView alloc]  initWithFrame:cell.contentView.frame];
    [v setBackgroundColor:[UIColor redColor]];
    [cell setSelectedBackgroundView:v];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.000001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    });
//    NSLog(@"log in vc");
    [[SHFileManager fileManager]  deleteAllSavedFiles];
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"log in vc deselect");
}
@end
