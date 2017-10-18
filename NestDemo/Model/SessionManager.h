//
//  SessionManager.h
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject

+(SessionManager *_Nullable)shared;

-(void)request:(NSURLRequest *_Nullable)request withCompletion:(void (^_Nullable)(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error))completion;

-(void)getDataWithMethod:(NSString *_Nonnull)method withCompletion:(void (^_Nullable)(NSDictionary * _Nullable json))completion withFailure:(void (^_Nullable)(NSError *_Nullable))failure;
-(void)setData:(NSData *_Nonnull)data withMethod:(NSString *_Nonnull)method withCompletion:(void (^_Nullable)(NSDictionary * _Nullable json))completion withFailure:(void (^_Nullable)(NSError *_Nullable))failure;

@end
