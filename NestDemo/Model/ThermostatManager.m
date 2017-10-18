//
//  ThermostatManager.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/20/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "ThermostatManager.h"
#import "SessionManager.h"

@interface ThermostatManager ()
@property (strong, nonatomic) NSString* thermostatId;

@end

@implementation ThermostatManager

@synthesize thermostatId;

NSString *const THERMOSTAT_METHOD = @"devices/thermostats/%@/";

-(instancetype)initWithThermostatId:(NSString *)thermostatId
{
    self = [super init];
    if (self) {
        self.thermostatId = thermostatId;
    }
    return self;
}

-(void)getDataWithCompletion:(void (^)(Thermostat * _Nullable))completion withFailure:(void (^)(NSError * _Nullable))failure
{
    [[SessionManager shared] getDataWithMethod:[NSString stringWithFormat:THERMOSTAT_METHOD, self.thermostatId] withCompletion:^(NSDictionary * _Nullable json) {
        Thermostat *thermostat = [[Thermostat alloc] initWithDictionary:json];
        completion(thermostat);
    } withFailure:^(NSError * _Nullable error) {
        failure(error);
    }];
}

-(void)setData:(NSInteger)targetTemp withCompletion:(void (^_Nullable)(NSDictionary * _Nullable json))completion withFailure:(void (^_Nullable)(NSError * _Nullable))failure
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"target_temperature_f": [NSNumber numberWithInteger:targetTemp]} options:NSJSONWritingPrettyPrinted error:nil];
    [[SessionManager shared] setData:data withMethod:[NSString stringWithFormat:THERMOSTAT_METHOD, self.thermostatId] withCompletion:^(NSDictionary *json) {
        completion(json);
    } withFailure:^(NSError *error) {
        failure(error);
    }];
}

@end
