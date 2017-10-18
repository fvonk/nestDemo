//
//  LoginViewController.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"

@protocol LoginFlowDelegate <NSObject>
-(void)accessTokenDidReceive;
@end

@interface LoginViewController : UIViewController <WebViewAuthDelegate>

@property (nonatomic, weak) id <LoginFlowDelegate> delegate;

@end
