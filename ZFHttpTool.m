//
//  ZFHttpTool.m
//
//  Created by zhongfeng on 16/9/21.
//  Copyright © 2016年 zhongfeng. All rights reserved.
//
//  或许你有疑问：为什么要再封装一次AFNetworking? AFNetworking已经封装好了啊！哪里用到网络请求哪里就调用AFNetworking就行啊！
//  答：将AFNetworking抽出来再封装成一个类：是因为如果将来AFNetworking有了新版，本项目需要更新网络框架了，只需来到这里更新AFNetworking就行了（就改这里写的AFNetworking的三个方法即可），而不用管项目的其它地方（其他地方调用网络请求，其实最终都会来到这里）。
//  如果不将AFNetworking封装成一个类，则项目的一个地方会用到AFNetworking，另一个地方也会用到AFNetworking，很多地方都会用到AFNetworking，则改起来很费事，维护起来较麻烦。

#import "ZFHttpTool.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>

@implementation ZFHttpTool

+(AFHTTPSessionManager *)sharedAFHTTPSessionManager {
    static AFHTTPSessionManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy.validatesDomainName = NO;
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    
    return manager;
}

#pragma mark - 利用AFNetworking发送GET请求
+(void)AFNetworking_GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [self sharedAFHTTPSessionManager];
    
    [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success == nil) return;
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return;
        failure(error);
    }];
}

#pragma mark - 利用AFNetworking发送POST请求
+(void)AFNetworking_PostWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [self sharedAFHTTPSessionManager];
    
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success == nil) return;
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure == nil) return;
        failure(error);
    }];
}

#pragma mark - 利用苹果自带的NSURLSession发送GET请求
+(void)NSURLSession_GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (success == nil) return;
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            success(dict);
        }else {
            if (failure == nil) return;
            failure(error);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - 利用苹果自带的NSURLSession发送POST请求
+(void)NSURLSession_PostWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSURLSession *session = [NSURLSession sharedSession];

    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLString]];
//    [URLRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    URLRequest.HTTPMethod = @"POST";
    
    NSMutableString *stringM = [NSMutableString string];
    
    if ([parameters isKindOfClass:[NSString class]]) {
        URLRequest.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        // 直接将字典解析为data，是不行的，程序崩溃；应将传进来的字典进行遍历，一一取出键值对进行拼接，拼接完毕再进行utf8转码为data
//        NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [stringM appendFormat:@"%@=%@&",key,obj];
        }];
        
        // 这句的作用是将最终的stringM中最后面的&去掉，实践证明：不去掉&也可以请求到数据，那就暂且不去掉了
//        NSString *bodyString = [stringM substringToIndex:stringM.length - 1];
//        NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        NSData *bodyData = [stringM dataUsingEncoding:NSUTF8StringEncoding];
        URLRequest.HTTPBody = bodyData;
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:URLRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (success == nil) return;
        if (data != nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            success(dict);
        }else {
            if (failure == nil) return;
            failure(error);
        }
    }];
    
    [dataTask resume];
}

#pragma mark - 利用SDWebImage下载图片
+(void)SDWebImage_downLoadImageForImageView:(UIImageView *)imageView URLString:(NSString *)URLString placeholder:(NSString *)placeholder {
    [imageView sd_setImageWithURL:[NSURL URLWithString:URLString] placeholderImage:[UIImage imageNamed:placeholder] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageContinueInBackground|SDWebImageHighPriority];// 下载图片失败后重新下载，scrollview滑动的时候延迟下载（不会产生卡顿的感觉），允许后台下载，允许优先下载（默认情况下，图像按顺序被加载到队列中。这个标志将它们移到队列的前面，并立即加载，而不是等待当前队列加载（可能需要一段时间））
}

+(void)SDWebImage_downLoadImageForButton:(UIButton *)button URLString:(NSString *)URLString placeholder:(NSString *)placeholder state:(UIControlState)state {
    [button sd_setImageWithURL:[NSURL URLWithString:URLString] forState:state placeholderImage:[UIImage imageNamed:placeholder] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageContinueInBackground|SDWebImageHighPriority];
}

+(UIImage *)SDWebImage_downLoadImageWithURLString:(NSString *)URLString placeholder:(NSString *)placeholder {
    UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]]];
    if (!image) {
        image = [UIImage imageNamed:placeholder];
    }
    
    return image;
}

@end
