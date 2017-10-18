//
//  WebViewController.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WebViewAuthDelegate <NSObject>
-(void)authorizationCodeReceived:(NSString *)code;
@end

@interface WebViewController : UIViewController
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) id <WebViewAuthDelegate> delegate;

@end
