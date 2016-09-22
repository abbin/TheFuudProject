//
//  TFPUser.h
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import <Parse/Parse.h>

@interface TFPUser : PFUser

@property (nonatomic, strong) PFFile *profilePicture;
@property (nonatomic, strong) NSString *displayName;

@end
