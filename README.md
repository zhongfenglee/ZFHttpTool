# ZFHttpTool
## 说明
网络请求工具-基于AFNetworking、苹果自带的NSURLSession、SDWebImage的二次封装，调用简单，易于维护。

代码中是AFNetworking的GET/POST请求，NSURLSession的GET/POST请求，SDWebImage下载图片的三个方法。

对这些框架继续封装的原因：

在开发中，很多地方都会用到网络功能，如果在这些地方直接调用这些网络框架，如果将来这些框架有了新版，你的项目可能需要更新这些网络框架，只需来到ZFHttpTool.m文件中进行更新即可，方便快捷。

## 使用方法
直接下载这两个文件，拖入到你的项目中。
