//
//  Device.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "Device.h"

@implementation Device

-(instancetype)initWithDictionary:(NSDictionary *)json
{
    self = [super init];
    if (self) {
        if ([json objectForKey:@"device_id"]) {
            self.ID = [json objectForKey:@"device_id"];
        }
        if ([json objectForKey:@"name"]) {
            self.name = [json objectForKey:@"name"];
        }
        if ([json objectForKey:@"structureId"]) {
            self.structureId = [json objectForKey:@"structureId"];
        }
        if ([json objectForKey:@"is_online"]) {
            self.isOnline = [[json objectForKey:@"is_online"] boolValue];
        }
    }
    
    return self;
}

@end
