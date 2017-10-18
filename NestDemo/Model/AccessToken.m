//
//  AccessToken.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/18/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "AccessToken.h"

@interface AccessToken () <NSCoding>

@property (nonatomic, readwrite) NSString *token;
@property (nonatomic, strong) NSDate *expireDate;

@end

@implementation AccessToken

-(instancetype)initWithToken:(NSString *)token andExpiration:(long)expiration
{
    self = [super init];
    if (self) {
        self.token = token;
        self.expireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)expiration];
    }
    return self;
}

-(BOOL)isAccessTokenValid
{
    return [[NSDate date] compare:self.expireDate] == NSOrderedAscending;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.expireDate forKey:@"expireDate"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.expireDate = [aDecoder decodeObjectForKey:@"expireDate"];
    }
    return self;
}



@end
