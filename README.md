# ZFHttpTool
## 说明
网络请求工具-基于AFNetworking、苹果自带的NSURLSession、SDWebImage的二次封装(AFNetworking的GET/POST请求，NSURLSession的GET/POST请求，SDWebImage下载图片)，调用简单，易于维护。

对这些框架继续封装的原因：

在开发中，很多地方会用到网络功能，若在这些地方直接使用这些网络框架，将来这些框架有了新版，项目中可能需更新网络框架，只需来到ZFHttpTool.m文件中进行更新即可（不用满项目中寻找那些用到这些框架的地方），方便快捷。

```
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
```
## 使用
直接下载这两个文件，拖入到你的项目中，然后`#import"ZFHttpTool"`

示例-使用AFNetworking发送POST请求：
```    
    [HttpTool AFNetworking_PostWithURLString:/*your URLString*/ parameters:/*your paramsDict*/ success:^(id responseObject) {
        // 请求成功，返回数据
        NSLog(@"responseObject:%@",responseObject);
        // 处理数据...
        
    } failure:^(NSError *error) {
        // 请求失败，错误处理
        NSLog(@"error:%@",error.localizedDescription);
    }];
```

## 联系我
如果您觉得此项目还不错，请为我加星，非常感谢，🙏！ 如果您有什么疑问/建议，欢迎联系我，🙏！

QQ/微信: 852354291    Email: 852354291@qq.com
