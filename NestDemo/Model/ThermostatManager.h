//
//  ThermostatManager.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/20/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Thermostat.h"

@interface ThermostatManager : NSObject

-(void)getDataWithCompletion:(void (^_Nullable)(Thermostat * _Nullable))completion withFailure:(void (^_Nullable)(NSError * _Nullable))failure;
-(void)setData:(NSInteger)targetTemp withCompletion:(void (^_Nullable)(NSDictionary * _Nullable))completion withFailure:(void (^_Nullable)(NSError * _Nullable))failure;

-(instancetype _Nonnull)initWithThermostatId:(NSString *_Nonnull)thermostatId;

@end
