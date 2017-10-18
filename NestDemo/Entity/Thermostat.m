//
//  Thermostat.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "Thermostat.h"

@implementation Thermostat

-(instancetype)initWithDictionary:(NSDictionary *)json
{
    self = [super initWithDictionary:json];
    if (self) {
        if ([json objectForKey:@"temperatureScale"]) {
            self.temperatureScale = [json objectForKey:@"temperature_scale"];
        }
        if ([json objectForKey:@"humidity"]) {
            self.humidity = [[json objectForKey:@"humidity"] integerValue];
        }
        if ([json objectForKey:@"ambient_temperature_f"]) {
            self.ambientTemperatureF = [[json objectForKey:@"ambient_temperature_f"] integerValue];
        }
        if ([json objectForKey:@"target_temperature_f"]) {
            self.targetTemperatureF = [[json objectForKey:@"target_temperature_f"] integerValue];
        }
        if ([json objectForKey:@"hvac_mode"]) {
            self.hvacMode = [json objectForKey:@"hvac_mode"];
        }
    }

    return self;
}

@end
