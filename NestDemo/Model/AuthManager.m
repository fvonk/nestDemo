//
//  AuthManager.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "AuthManager.h"
#import "AccessToken.h"
#import "Configs.h"
#import "SessionManager.h"

@interface AuthManager () 

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *secretId;

@end

@implementation AuthManager

+(AuthManager *)shared
{
    static AuthManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AuthManager alloc] init];
    });
    return instance;
}

-(void)setProductId:(NSString *)clientId andSecret:(NSString *)secretId
{
    self.clientId = clientId;
    self.secretId = secretId;
}

-(NSString *)getAuthUrl
{
    return [NSString stringWithFormat:@"%@?client_id=%@&state=STATE", kAuthUrl, self.clientId];
}

-(BOOL)isUserAuthenticated
{
    if ([self getAccessToken]) {
        return YES;
    } else {
        return NO;
    }
}

-(NSString *)getAccessToken
{
    NSData *accessTokenData = [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    if (accessTokenData) {
        AccessToken *accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:accessTokenData];
        if ([accessToken isAccessTokenValid]) {
            return accessToken.token;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(void)saveAuthorizatonCode:(NSString *)code
{
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:AUTHORIZATION_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)requestAccessTokenByAuthCode:(NSString *)code withCompetion:(void (^)(void))completion
{
    [self saveAuthorizatonCode:code];
    
    NSString *accessTokenUrl = [NSString stringWithFormat:@"%@%@%@", OAUTHURL, GET_ACCESSTOKE_URL,
                                [NSString stringWithFormat:@"?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", code, self.clientId, self.secretId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:accessTokenUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"form-data" forHTTPHeaderField:@"Content-Type"];
    
    [[SessionManager shared] request:request withCompletion:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        long expiresIn = [[json objectForKey:@"expires_in"] longValue];
        NSString *accessToken = [json objectForKey:@"access_token"];
        [self saveAccessToken:accessToken withExpiration:expiresIn];
        completion();
    }];
}

- (void)saveAccessToken:(NSString *)token withExpiration:(long)expiration
{
    AccessToken *accessToken = [[AccessToken alloc] initWithToken:token andExpiration:expiration];
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)logoutUserWithCompletion:(void (^)(void))completion
{
    NSString *logoutUrl = [NSString stringWithFormat:@"%@%@%@", OAUTHURL, LOGOUT_URL, [self getAccessToken]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:logoutUrl]];
    [request setHTTPMethod:@"DELETE"];
    
    [[SessionManager shared] request:request withCompletion:^(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self dropAccessToken];
        [self dropAuthorizationCode];
        completion();
    }];
}

-(void)dropAccessToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)dropAuthorizationCode
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AUTHORIZATION_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
