//
//  ZFHttpTool.h
//
//  Created by zhongfeng on 16/9/21.
//  Copyright © 2016年 zhongfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIControl.h>

@class UIImageView;
@class UIButton;

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

@interface ZFHttpTool : NSObject

// AFNetworking发送网络请求
+(void)AFNetworking_GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)AFNetworking_PostWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

// Apple自带的发送网络请求
+(void)NSURLSession_GetWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;
+(void)NSURLSession_PostWithURLString:(NSString *)URLString parameters:(id)parameters success:(SuccessBlock)success failure:(FailureBlock)failure;

// 利用SDWebImage下载图片
+(void)SDWebImage_downLoadImageForImageView:(UIImageView *)imageView URLString:(NSString *)URLString placeholder:(NSString *)placeholder;
+(void)SDWebImage_downLoadImageForButton:(UIButton *)button URLString:(NSString *)URLString placeholder:(NSString *)placeholder state:(UIControlState)state;
+(UIImage *)SDWebImage_downLoadImageWithURLString:(NSString *)URLString placeholder:(NSString *)placeholder;

@end
