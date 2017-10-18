//
//  Configs.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configs.h"

NSString * const kProductID = @"851e5e65-f8b1-4dda-a17f-50e944332285";
NSString * const kProductSecret = @"jnp2ETapw7QWiw1MV8d3ateFw";

NSString * const RedirectURL = @"http://localhost:8080/auth/nest/callback";

NSString *const ACCESS_TOKEN = @"ACCESS_TOKEN";
NSString *const AUTHORIZATION_CODE = @"AUTHORIZATION_CODE";

NSString *const API_URL = @"https://developer-api.nest.com";
NSString *const OAUTHURL = @"https://api.home.nest.com/oauth2/";
NSString *const GET_ACCESSTOKE_URL = @"access_token";
NSString *const LOGOUT_URL = @"access_tokens/";
NSString *const kAuthUrl = @"https://home.nest.com/login/oauth2";

NSTimeInterval const UPDATE_TIME_INTERVAL = 30;
