//
//  SessionManager.m
//  NestDemo
//
//  Created by Pavel Kozlov on 10/19/17.
//  Copyright © 2017 Pavel Kozlov. All rights reserved.
//

#import "SessionManager.h"
#import "AuthManager.h"
#import "Configs.h"

@interface SessionManager ()
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SessionManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

+(SessionManager *)shared
{
    static SessionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SessionManager alloc] init];
    });
    return instance;
}

-(void)request:(NSURLRequest *)request withCompletion:(void (^)(NSDictionary * _Nullable json, NSURLResponse * _Nullable response, NSError * _Nullable error))completion
{
    [[self.session dataTaskWithRequest:request completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        completion(json, response, error);
    }] resume];
}

-(void)getDataWithMethod:(NSString *)method withCompletion:(void (^)(NSDictionary *json))completion withFailure:(void (^)(NSError *))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_URL, method];
    [self requestDataWithUrl:urlString andType:@"GET" andData:nil withCompletion:completion withFailure:failure];
}

-(void)setData:(NSData *)data withMethod:(NSString *)method withCompletion:(void (^)(NSDictionary *json))completion withFailure:(void (^)(NSError *))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", API_URL, method];
    [self requestDataWithUrl:urlString andType:@"PUT" andData:data withCompletion:completion withFailure:failure];
}

-(void)requestDataWithUrl:(NSString *)urlString andType:(NSString *)type andData:(NSData *)inputData withCompletion:(void (^)(NSDictionary *json))completion withFailure:(void (^)(NSError *))failure
{
    NSURLRequest *request = [self getRequestWithUrl:urlString withMethod:type withData:inputData];
    __weak __typeof(self)weakSelf = self;
    [[self.session dataTaskWithRequest:request completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ((long)[(NSHTTPURLResponse *)response statusCode] == 401 || (long)[(NSHTTPURLResponse *)response statusCode] == 307) {
            NSString *redirectURL = [NSString stringWithFormat:@"%@", [(NSHTTPURLResponse *)response URL]];
            [weakSelf requestDataWithUrl:redirectURL andType:type andData:inputData withCompletion:completion withFailure:failure];
        } else {
            if (data) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (!error) {
                    completion(json);
                    return;
                }
            }
            failure(error);
        }
    }] resume];
}

-(NSURLRequest *)getRequestWithUrl:(NSString *)url withMethod:(NSString *)method withData:(NSData *)data
{
    NSString *authBearer = [NSString stringWithFormat:@"Bearer %@", [[AuthManager shared] getAccessToken]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authBearer forHTTPHeaderField:@"Authorization"];
    [request setURL:[NSURL URLWithString:url]];
    if (data) {
        [request setHTTPBody:data];
    }
    return request;
}

@end
