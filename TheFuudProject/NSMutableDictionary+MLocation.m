//
//  NSMutableDictionary+MLocation.m
//  Menu
//
//  Created by Abbin Varghese on 09/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "NSMutableDictionary+MLocation.h"

NSString *const kFALocationFullNameKey                      = @"locationFullName";
NSString *const kFALocationShortNameKey                      = @"locationShortName";
NSString *const kFALocationLatitudeKey                      = @"locationLatitude";
NSString *const kFALocationLongitudeKey                      = @"locationLongitude";

@implementation NSMutableDictionary (MLocation)

@dynamic locationFullName;
@dynamic locationShortName;
@dynamic locationLatitude;
@dynamic locationLongitude;

-(void)setLocationFullName:(NSString *)locationFullName{
    [self setObject:locationFullName forKey:kFALocationFullNameKey];
}

-(void)setLocationShortName:(NSString *)locationShortName{
    [self setObject:locationShortName forKey:kFALocationShortNameKey];
}

-(void)setLocationLatitude:(NSNumber *)locationLatitude{
    [self setObject:locationLatitude forKey:kFALocationLatitudeKey];
}

-(void)setLocationLongitude:(NSNumber *)locationLongitude{
    [self setObject:locationLongitude forKey:kFALocationLongitudeKey];
}

-(NSString *)locationFullName{
    return [self objectForKey:kFALocationFullNameKey];
}

-(NSString *)locationShortName{
    return [self objectForKey:kFALocationShortNameKey];
}

-(NSNumber *)locationLatitude{
    return [self objectForKey:kFALocationLatitudeKey];
}

-(NSNumber *)locationLongitude{
    return [self objectForKey:kFALocationLongitudeKey];
}

-(instancetype)initLocationWithDictionary:(NSDictionary*)dictionary{
    self = [self init];
    if (self) {
        @try {
            self.locationFullName = [dictionary objectForKey:@"formatted_address"];
        } @catch (NSException *exception) {
            self.locationFullName = @"";
        }
        @try {
            self.locationShortName = [dictionary objectForKey:@"name"];
        } @catch (NSException *exception) {
            self.locationShortName = @"";
        }
        
        @try {
            self.locationLatitude = [NSNumber numberWithDouble:[[[[dictionary objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] doubleValue]];
        } @catch (NSException *exception) {
        }
        
        @try {
            self.locationLongitude = [NSNumber numberWithDouble:[[[[dictionary objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] doubleValue]];
        } @catch (NSException *exception) {
        }
        
    }
    return self;
}

@end
