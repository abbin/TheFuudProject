//
//  TFPUser.m
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "TFPUser.h"
#import <Parse/PFObject+Subclass.h>

@implementation TFPUser

@dynamic profilePicture;
@dynamic displayName;

+ (void)load {
    [self registerSubclass];
}

@end
