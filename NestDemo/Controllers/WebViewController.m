//
//  WebViewController.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "WebViewController.h"
#import "Configs.h"
#import "UIViewController+Spinner.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation WebViewController

@synthesize webView, url, indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:cancelBarButton];
    
    indicator = [self setupIndicator];
    [indicator startAnimating];
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

-(void)cancel:(UIBarButtonItem *)button
{
    [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [indicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] host] isEqualToString:[[NSURL URLWithString:RedirectURL] host]]) {
        NSArray *components = [[[request URL] absoluteString] componentsSeparatedByString:@"&"];
        for (NSString *component in components) {
            if ([component containsString:@"code="]) {
                NSString *code = [[component componentsSeparatedByString:@"="] lastObject];
                if ([self.delegate conformsToProtocol:@protocol(WebViewAuthDelegate)]) {
                    [self.delegate authorizationCodeReceived:code];
                }
                [[self presentingViewController] dismissViewControllerAnimated:true completion:nil];
            }
        }
        
        return NO;
    } else {
        return YES;
    }
}

@end
