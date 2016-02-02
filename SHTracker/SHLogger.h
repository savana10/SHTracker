//
//  SHLogger.h
//  SHTracker
//
//  Created by Savana on 27/01/16.
//  Copyright (c) 2016 Savana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHLogger : NSObject
//! Number of taps required to display Send Log options , by default is 3 if number is less than 2 it is set to default value
@property int noOfTaps;
+(SHLogger *) logger;
//! Log any NSDictionary in Local file
-(void) log:(NSDictionary *) details;
@end
