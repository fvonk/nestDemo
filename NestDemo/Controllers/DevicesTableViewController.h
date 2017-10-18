//
//  DevicesTableViewController.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LogoutFlowDelegate <NSObject>
-(void)logoutUser;
@end

@interface DevicesTableViewController : UITableViewController

@property (nonatomic, weak) id <LogoutFlowDelegate> delegate;

@end
