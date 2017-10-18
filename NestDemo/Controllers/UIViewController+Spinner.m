//
//  UIViewController+Spinner.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "UIViewController+Spinner.h"

@implementation UIViewController (Spinner)

-(UIActivityIndicatorView *)setupIndicator
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.hidesWhenStopped = YES;
    UIBarButtonItem *barAcitivity = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    [self.navigationItem setRightBarButtonItem:barAcitivity];
    return indicator;
}

@end
