//
//  AccessToken.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (nonatomic, readonly) NSString *token;

-(instancetype)initWithToken:(NSString *)token andExpiration:(long)expiration;
-(BOOL)isAccessTokenValid;

@end
