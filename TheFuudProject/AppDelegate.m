//
//  AppDelegate.m
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TFPManager.h"
#import "TFPSigninViewController.h"
#import "TFPCurrentLocationViewController.h"
#import "TFPUser.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"C4F3184BCDCD4AFC842AD0DA372399F6";
        configuration.server = @"http://parseserver-3ix23-env.us-west-2.elasticbeanstalk.com/parse";
    }]];
    
    if (![TFPManager isLocationSet]) {
        if (![TFPUser currentUser]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TFPSigninViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFPSigninViewController"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TFPCurrentLocationViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFPCurrentLocationViewController"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)changeRootViewController:(UIViewController*)viewController {
    self.window.rootViewController = viewController;
}

@end
