//
//  Camera.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "Camera.h"

@implementation Camera

-(instancetype)initWithDictionary:(NSDictionary *)json
{
    self = [super initWithDictionary:json];
    if (self) {
        if ([json objectForKey:@"web_url"]) {
            self.webUrl = [json objectForKey:@"web_url"];
        }
    }
    return self;
}

@end
