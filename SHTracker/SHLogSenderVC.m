//
//  SHLogSenderVC.m
//  SHTracker
//
//  Created by Savana on 01/02/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import "SHLogSenderVC.h"
#import "SHFileManager.h"
@import MessageUI;
#import <sys/sysctl.h>
#import <sys/utsname.h>

@interface SHLogSenderVC ()<MFMailComposeViewControllerDelegate>

@end

@implementation SHLogSenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *buttonTitles = @[@"Send Current",@"Send Last",@"Send All",@"Clear All"];
    UIToolbar *tb =[[UIToolbar alloc]  initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64.0f)];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goBack)];
    [tb setItems:@[back]];
    [self.view addSubview:tb];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel *l = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 160, 40)];
    [l setCenter:tb.center];
    [l setText:@"Log Options"];
    [l setTextAlignment:NSTextAlignmentCenter];
    [tb addSubview:l];
    
    for (int i = 0 ; i<buttonTitles.count ; i++) {
        UIButton *actBut = [[UIButton alloc]  initWithFrame:CGRectMake(0, 80+(i*80), 140, 40)];
        [actBut setTag:i];
        [actBut addTarget:self action:@selector(sh_logButton:) forControlEvents:UIControlEventTouchUpInside];
        [actBut setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [actBut setTitleColor:actBut.tintColor forState:UIControlStateNormal];
        [actBut setCenter:CGPointMake(self.view.center.x,actBut.center.y)];
        actBut.layer.borderColor = actBut.tintColor.CGColor;
        actBut.layer.borderWidth = 2.0f;
        actBut.layer.cornerRadius = 5.0f;
        [self.view addSubview:actBut];
    }
    
}

-(void) sh_logButton:(UIButton *)sender
{
    if (sender.tag == 3) {
        [[SHFileManager fileManager]  deleteAllSavedFiles];
    }else{
        [self getFilesWithOptions:(int)sender.tag];
    }
}
-(void) getFilesWithOptions:(int) option
{
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc]  init];
    NSArray *t = [[SHFileManager fileManager] fetchLogFileWith:option];
    NSString *fileName = (option == 0)?@"CurrentLog":@"lastLog";
    if (option == 2) {
        fileName = @"logFile";
    }
    for (NSString *s in t) {
        [mailVC addAttachmentData:[NSData dataWithContentsOfFile:s] mimeType:@"text" fileName:fileName];
    }
    [mailVC setMailComposeDelegate:self];
    NSMutableString *bodyText = [NSMutableString stringWithString:@"Device Details \n "];
    NSDictionary *dict =[[NSBundle mainBundle] infoDictionary];
    struct utsname systemInfo;
    uname(&systemInfo);
    NSMutableDictionary *parameters  = [NSMutableDictionary new];
    NSString *deviceName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    [parameters setObject:[dict objectForKey:(NSString *)kCFBundleVersionKey] forKey:@"appVersion"];
    [parameters setObject:[dict objectForKey:(NSString *) kCFBundleIdentifierKey] forKey:@"applicationId"];
    [parameters setObject:[[UIDevice currentDevice] systemName] forKey:@"os"];
    [parameters setObject:[[UIDevice currentDevice]systemVersion] forKey:@"osVersion"];
    [parameters setObject:deviceName forKey:@"deviceName"];
    for (NSString *key in parameters) {
        [bodyText appendString:[NSString stringWithFormat:@"%@ : %@ \n",key,[parameters objectForKey:key]]];
    }
    [mailVC setMessageBody:bodyText isHTML:NO];
    [mailVC setSubject:@"Log details"];
    [self presentViewController:mailVC animated:true completion:nil];
    
}
-(void) goBack
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:true completion:nil];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
