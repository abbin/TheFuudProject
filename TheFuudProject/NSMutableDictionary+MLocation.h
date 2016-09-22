//
//  NSMutableDictionary+MLocation.h
//  Menu
//
//  Created by Abbin Varghese on 09/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kFALocationFullNameKey;
FOUNDATION_EXPORT NSString *const kFALocationShortNameKey;
FOUNDATION_EXPORT NSString *const kFALocationLatitudeKey;
FOUNDATION_EXPORT NSString *const kFALocationLongitudeKey;

@interface NSMutableDictionary (MLocation)

@property (nonatomic, strong) NSString *locationFullName;
@property (nonatomic, strong) NSString *locationShortName;
@property (strong, nonatomic) NSNumber *locationLatitude;
@property (strong, nonatomic) NSNumber *locationLongitude;

-(instancetype)initLocationWithDictionary:(NSDictionary*)dictionary;

@end
