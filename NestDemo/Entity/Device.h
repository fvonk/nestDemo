//
//  Device.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *structureId;
@property (nonatomic, assign) BOOL isOnline;

-(instancetype)initWithDictionary:(NSDictionary *)json;

@end
