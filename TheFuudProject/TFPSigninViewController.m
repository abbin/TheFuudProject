//
//  TFPSigninViewController.m
//  TheFuudProject
//
//  Created by Abbin Varghese on 22/09/16.
//  Copyright © 2016 Fuudapp. All rights reserved.
//

#import "TFPSigninViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TFPUser.h"
#import "TFPManager.h"
#import "TFPCurrentLocationViewController.h"
#import "AppDelegate.h"

@interface TFPSigninViewController ()<FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (nonatomic, strong) AVPlayer *avplayer;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation TFPSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_0102" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*9/16)];
    [self.playerView.layer addSublayer:avPlayerLayer];
    
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.avplayer play];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void)playerStartPlaying
{
    [self.avplayer play];
}

- (BOOL)isModal {
    return self.presentingViewController.presentedViewController == self
    || (self.navigationController != nil && self.navigationController.presentingViewController.presentedViewController == self.navigationController)
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    if (error == nil && [FBSDKAccessToken currentAccessToken].tokenString) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,first_name,last_name,email,picture.width(100).height(100)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                if ([result objectForKey:@"email"]) {
                    TFPUser *user = [TFPUser user];
                    user.password = @"password";
                    user.email = [result objectForKey:@"email"];
                    user.username = [result objectForKey:@"email"];
                    user.displayName = [NSString stringWithFormat:@"%@ %@",[result objectForKey:@"first_name"],[result objectForKey:@"last_name"]];
                    NSString *url = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                    PFFile *image;
                    if (url.length>0) {
                        image = [PFFile fileWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
                    }
                    if (image) {
                        user.profilePicture = image;
                    }
                    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            if (![TFPManager isLocationSet]) {
                                TFPCurrentLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPCurrentLocationViewController"];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                            else{
                                if ([self isModal]) {
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }
                                else{
                                    UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPTabBarController"];
                                    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                    [delegate changeRootViewController:vc];
                                }
                            }
                        }else{
                            if (error.code == 202 || error.code == 203) {
                                [PFUser logInWithUsernameInBackground:[result objectForKey:@"email"] password:@"password"
                                                                block:^(PFUser *user, NSError *error) {
                                                                    if (user && error == nil) {
                                                                        if (![TFPManager isLocationSet]) {
                                                                            TFPCurrentLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPCurrentLocationViewController"];
                                                                            [self.navigationController pushViewController:vc animated:YES];
                                                                        }
                                                                        else{
                                                                            if ([self isModal]) {
                                                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                                            }
                                                                            else{
                                                                                UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPTabBarController"];
                                                                                AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                                                                                [delegate changeRootViewController:vc];
                                                                            }
                                                                        }
                                                                    }
                                                                }];
                            }
                        }
                    }];
                    
                }
            }
        }];
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (IBAction)signinLater:(id)sender {
    if (![TFPManager isLocationSet]) {
        TFPCurrentLocationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPCurrentLocationViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        if ([self isModal]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else{
            UITabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TFPTabBarController"];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [delegate changeRootViewController:vc];
        }
    }
}

@end
