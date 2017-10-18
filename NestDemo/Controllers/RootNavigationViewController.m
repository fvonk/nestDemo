//
//  RootNavigationViewController.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "RootNavigationViewController.h"
#import "AuthManager.h"
#import "LoginViewController.h"
#import "DevicesTableViewController.h"
#import "Configs.h"

@interface RootNavigationViewController () <LoginFlowDelegate, LogoutFlowDelegate>

@end

@implementation RootNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AuthManager shared] setProductId:kProductID andSecret:kProductSecret];
    
    if (![[AuthManager shared] isUserAuthenticated]) {
        [self showLoginViewController];
    } else {
        [self showDevicesTableViewController];
    }
}

-(void)accessTokenDidReceive
{
    [self showDevicesTableViewController];
}

-(void)logoutUser
{
    __weak __typeof(self)weakSelf = self;
    [[AuthManager shared] logoutUserWithCompletion:^{
        [weakSelf showLoginViewController];
    }];
}

-(void)showDevicesTableViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DevicesTableViewController *devicesTableViewController = [storyboard instantiateViewControllerWithIdentifier:@"DevicesTableViewController"];
    [devicesTableViewController setDelegate:self];
    [self popToRootViewControllerAnimated:YES];
    [self setViewControllers:@[devicesTableViewController]];
}

-(void)showLoginViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [loginViewController setDelegate:self];
    [self popToRootViewControllerAnimated:YES];
    [self setViewControllers:@[loginViewController]];
}

@end
