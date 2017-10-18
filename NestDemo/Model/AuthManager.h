//
//  AuthManager.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthManager : NSObject

-(void)setProductId:(NSString *)clientId andSecret:(NSString *)secretId;

+(AuthManager *)shared;

-(NSString *)getAuthUrl;

-(BOOL)isUserAuthenticated;
-(NSString *)getAccessToken;

-(void)requestAccessTokenByAuthCode:(NSString *)code withCompetion:(void (^)(void))completion;
-(void)logoutUserWithCompletion:(void (^)(void))completion;

@end
