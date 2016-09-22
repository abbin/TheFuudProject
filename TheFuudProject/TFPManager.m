//
//  TFPManager.m
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "TFPManager.h"
#import "TFPConstants.h"

@implementation TFPManager

+(BOOL)isLocationSet{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kTFPCurrentLocationKey]) {
        return YES;
    }
    else{
        return NO;
    }
}

@end
