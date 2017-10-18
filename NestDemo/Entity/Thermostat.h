//
//  Thermostat.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"

@interface Thermostat : Device

@property (nonatomic, assign) BOOL hasFan;
@property (nonatomic, strong) NSString *temperatureScale;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger ambientTemperatureF;
@property (nonatomic, assign) NSInteger targetTemperatureF;
@property (nonatomic, strong) NSString *hvacMode;

@end
