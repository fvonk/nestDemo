//
//  LoginViewController.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthManager.h"
#import "Configs.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)loginAction:(UIButton *)sender
{
    [self showWebViewController];
}

-(void)showWebViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewController = [storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    [webViewController setUrl:[NSURL URLWithString:[[AuthManager shared] getAuthUrl]]];
    [webViewController setDelegate:self];
    UINavigationController *navigationController =[[UINavigationController alloc] initWithRootViewController:webViewController];
    [[self navigationController] presentViewController:navigationController animated:true completion:nil];
}

-(void)authorizationCodeReceived:(NSString *)code
{
    [self.loginButton setEnabled:NO];
    [self.loginButton setTitle:@"Loading..." forState:UIControlStateNormal];
    [self.spinner startAnimating];
    __weak __typeof(self)weakSelf = self;
    [[AuthManager shared] requestAccessTokenByAuthCode:code withCompetion:^{
        if ([weakSelf.delegate conformsToProtocol:@protocol(LoginFlowDelegate)]) {
            [weakSelf.delegate accessTokenDidReceive];
            [weakSelf.spinner stopAnimating];
        }
    }];
}

@end
