---
title: react-native 集成微信支付
date: 2017-12-11 09:39:45
description: 上篇文章已经介绍过 react-native 集成支付宝，本篇文章将基于微信支付官方提供的集成文档，介绍如何将微信支付集成到 react-native 应用中。
tags:
  - React
  - ReactNative
categories:
  - Front
---
上篇文章已经介绍过 [react-native 集成支付宝](http://fangzf.me/2017/12/05/react-native-%E9%9B%86%E6%88%90%E6%94%AF%E4%BB%98%E5%AE%9D/)，本篇文章将基于微信支付官方提供的集成文档，介绍如何将微信支付集成到 react-native 应用中。

## 场景介绍
>适用于商户在移动端APP中集成微信支付功能。
商户APP调用微信提供的SDK调用微信支付模块，商户APP会跳转到微信中完成支付。
支付完后跳回到商户APP内，最后展示支付结果。
目前微信支付支持手机系统有：IOS（苹果）、Android（安卓）和WP（Windows Phone）。

## 集成SDK
获取APPID：商户在[微信开放平台](https://open.weixin.qq.com/)申请开发APP应用后，微信开放平台会生成APP的唯一标识APPID。
### Android
1. 后台设置
商户在微信开放平台申请开发应用后，微信开放平台会生成APP的唯一标识APPID。由于需要保证支付安全，需要在开放平台绑定商户应用包名和应用签名，设置好后才能正常发起支付。设置界面在【开放平台】中的栏目【管理中心 / 修改应用 / 修改开发信息】里面，如下图红框内所示。
![](https://pay.weixin.qq.com/wiki/doc/api/img/chapter8_5_2.png)
应用签名获取可以使用：[应用签名获取工具](https://open.weixin.qq.com/zh_CN/htmledition/res/dev/download/sdk/Gen_Signature_Android.apk)，将安装包安装到手机里，输入应用包名即可获取到签名。
![](https://pay.weixin.qq.com/wiki/doc/api/img/chapter8_5_3.png)
这里有个调试技巧，可以将应用的签名改为 debug 版本的签名，等支付调试完成后再改为生产环境的签名。
2. 导入微信SDK，修改`android/app/build.gradle`添加如下代码：
```js
dependencies {
    ......
    compile "com.tencent.mm.opensdk:wechat-sdk-android-with-mta:+"
    ......
}
```
3. 在`com.xx.xx`创建包名`wxapi`，**注意此处包名一定要为`wxapi`，否则后续将无法处理回调**
4. 编写 Module，在`com.xx.xx.wxapi`包下创建`WxpayModule.java`，代码如下：
  ```java
  package com.xx.xx.wxapi;

  import com.facebook.react.bridge.Promise;
  import com.facebook.react.bridge.ReactApplicationContext;
  import com.facebook.react.bridge.ReactContextBaseJavaModule;
  import com.facebook.react.bridge.ReactMethod;
  import com.facebook.react.bridge.ReadableMap;
  import com.tencent.mm.opensdk.modelpay.PayReq;
  import com.tencent.mm.opensdk.openapi.IWXAPI;
  import com.tencent.mm.opensdk.openapi.WXAPIFactory;

  class WxpayModule extends ReactContextBaseJavaModule {

    private IWXAPI api;
    static String APP_ID = "";
    static Promise promise = null;

    WxpayModule(ReactApplicationContext reactContext) {
      super(reactContext);
      api = WXAPIFactory.createWXAPI(reactContext, null);
    }

    @Override
    public String getName() {
      return "Wxpay";
    }

    @ReactMethod
    public void registerApp(String APP_ID) { // 向微信注册
      WxpayModule.APP_ID = APP_ID;
      api.registerApp(APP_ID);
    }

    @ReactMethod
    public void pay(final ReadableMap order, Promise promise) {
      WxpayModule.promise = promise;
      PayReq request = new PayReq();
      request.appId = order.getString("appid");
      request.partnerId = order.getString("partnerid");
      request.prepayId= order.getString("prepayid");
      request.packageValue = order.getString("package");
      request.nonceStr= order.getString("noncestr");
      request.timeStamp= order.getInt("timestamp")+"";
      request.sign= order.getString("sign");
      api.sendReq(request);
    }

    @ReactMethod
    public void isSupported(Promise promise) { // 判断是否支持调用微信SDK
      boolean isSupported = api.isWXAppInstalled();
      promise.resolve(isSupported);
    }

  }
  ```
5. 编写 Package，在`com.xx.xx.wxapi`包下创建`WxpayPackage.java`，代码如下：
  ```java
  package com.xx.xx.wxapi;

  import com.facebook.react.ReactPackage;
  import com.facebook.react.bridge.NativeModule;
  import com.facebook.react.bridge.ReactApplicationContext;
  import com.facebook.react.uimanager.ViewManager;

  import java.util.ArrayList;
  import java.util.Collections;
  import java.util.List;

  public class WxpayPackage implements ReactPackage {

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
      return Collections.emptyList();
    }

    @Override
    public List<NativeModule> createNativeModules(
            ReactApplicationContext reactContext) {
      List<NativeModule> modules = new ArrayList<>();
      modules.add(new WxpayModule(reactContext));
      return modules;
    }

  }
  ```
6. 编写 WXPayEntryActivity 处理微信支付回调，在`com.xx.xx.wxapi`包下创建`WXPayEntryActivity.java`，**注意包名或类名不一致会造成无法回调**，代码如下：
  ```java
  package com.xx.xx.wxapi;

  import android.app.Activity;
  import android.content.Intent;
  import android.os.Bundle;
  import android.util.Log;

  import com.facebook.react.bridge.Arguments;
  import com.facebook.react.bridge.WritableMap;
  import com.tencent.mm.opensdk.constants.ConstantsAPI;
  import com.tencent.mm.opensdk.modelbase.BaseReq;
  import com.tencent.mm.opensdk.modelbase.BaseResp;
  import com.tencent.mm.opensdk.openapi.IWXAPI;
  import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
  import com.tencent.mm.opensdk.openapi.WXAPIFactory;

  public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {
    
      private static final String TAG = "WXPayEntryActivity";
      private IWXAPI api;
    
      @Override
      public void onCreate(Bundle savedInstanceState) {
          super.onCreate(savedInstanceState);
        api = WXAPIFactory.createWXAPI(this, WxpayModule.APP_ID);
          api.handleIntent(getIntent(), this);
      }

    @Override
    protected void onNewIntent(Intent intent) {
      super.onNewIntent(intent);
      setIntent(intent);
          api.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq req) {
    }

    @Override
    public void onResp(BaseResp resp) {
      Log.d(TAG, "onPayFinish, errCode = " + resp.errCode);
      if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
        WritableMap map = Arguments.createMap();
        map.putInt("errCode", resp.errCode);
        WxpayModule.promise.resolve(map);
        finish();
      }
    }
  }
  ```
7. 最后在 Android 这边要做的最后一件事就是注册这个模块，在`com.xx.xx.MainApplication`中注册模块：
  ```java
  @Override
  protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          // ...other packages
          new WxpayPackage() // <-- 注册模块
      );
  }
  ```
### iOS
1. 项目设置APPID，在Xcode中打开项目，设置项目属性中的URL Schemes为你的APPID。如图标红位置所示：
![](https://pay.weixin.qq.com/wiki/doc/api/img/chapter8_5_1.png)
2. 添加微信白名单
`info.plist` --> 右击 --> `open as`  --> `source Code` --> 添加白名单，如下图所示：
![2017-12-11-14-28-10](http://p0gxdxnc4.bkt.clouddn.com/2017-12-11-14-28-10.png)
代码如下：
```xml
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>wechat</string>
        <string>weixin</string>
    </array>
</key>
```
3. 导入必要的库文件，如下图所示：
![2017-12-11-14-30-54](http://p0gxdxnc4.bkt.clouddn.com/2017-12-11-14-30-54.png)
4. 在项目目录下创建Group `Wxapi`，并创建`WxpayModule`模块
5. 下载开发工具包（[SDK](https://res.wx.qq.com/op_res/qNjut2h9J8oE9o2zeJTAYdCTgB7hM5pHAkJz1rNNCOnSyKA2bwzBv3fQILqbD_c1)），导入`Wxapi`中，最终如下图所示：
![2017-12-11-15-05-34](http://p0gxdxnc4.bkt.clouddn.com/2017-12-11-15-05-34.png)
6. 编写`WxpayModule.h`代码如下：
  ```objectivec
  #import <React/RCTBridgeModule.h>
  #import <React/RCTLog.h>
  #import "WXApiObject.h"
  #import "WXApi.h"

  @interface WxpayModule : NSObject <RCTBridgeModule, WXApiDelegate>
  @end
  ```
7. 编写`WxpayModule.m`代码如下：
  ```objectivec
  #import "WxpayModule.h"

  @implementation WxpayModule

  RCTPromiseResolveBlock resolveBlock = nil;

  - (instancetype)init
  {
    self = [super init];
    if (self) {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXPay:) name:@"WXPay" object:nil];
    }
    return self;
  }

  - (void)dealloc
  {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  }

  - (void)handleWXPay:(NSNotification *)aNotification
  {
    NSString * errCode =  [aNotification userInfo][@"errCode"];
    resolveBlock(@{@"errCode": errCode});
  }

  RCT_EXPORT_METHOD(registerApp:(NSString *)APP_ID){
    [WXApi registerApp: APP_ID];//向微信注册
  }

  RCT_EXPORT_METHOD(pay:(NSDictionary *)order
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject){
    resolveBlock = resolve;
    //调起微信支付
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [order objectForKey:@"partnerid"];
    req.prepayId = [order objectForKey:@"prepayid"];
    req.nonceStr = [order objectForKey:@"noncestr"];
    req.timeStamp = [[order objectForKey:@"timestamp"] intValue];
    req.package = [order objectForKey:@"package"];
    req.sign = [order objectForKey:@"sign"];
    [WXApi sendReq:req];
  }

  RCT_REMAP_METHOD(isSupported, // 判断是否支持调用微信SDK
                    resolver:(RCTPromiseResolveBlock)resolve
                    rejecter:(RCTPromiseRejectBlock)reject){
    if (![WXApi isWXAppInstalled]) resolve(@NO);
    else resolve(@YES);
  }

  RCT_EXPORT_MODULE(Wxpay);

  @end
  ```
8. 处理微信支付回调，在`AppDelegate.m`中添加如下代码：
  ```objectivec
  //支付回调9以后
  - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options {
    return  [WXApi handleOpenURL:url delegate:self];
  }
  //支付回调9以前
  - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
  }
  //ios9以后的方法
  - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
  }

  #pragma mark - wx callback

  - (void) onReq:(BaseReq*)req
  {
    // TODO Something
  }

  - (void)onResp:(BaseResp *)resp
  {
    //判断是否是微信支付回调 (注意是PayResp 而不是PayReq)
    if ([resp isKindOfClass:[PayResp class]])
    {
      //发出通知 从微信回调回来之后,发一个通知,让请求支付的页面接收消息,并且展示出来,或者进行一些自定义的展示或者跳转
      NSNotification * notification = [NSNotification notificationWithName:@"WXPay" object:nil userInfo:@{@"errCode":@(resp.errCode)}];
      [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
  }
  ```
9. 至此，iOS端微信SDK集成成功

### React-Native
1. 修改原生代码后，需要重新打包运行程序：
```shell
react-native run-android # 运行Android端
react-native run-ios # 运行iOS端
```
2. 编写`Wxpay.js`工具类
```js
import { NativeModules } from 'react-native';
export default NativeModules.Wxpay;
```
3. 在入口文件`index.js`向微信注册应用
```js
import Wxpay from './your/path/to/Wxpay';
Wxpay.registerApp(APPID); //向微信注册
```
4. 调用`Wxpay`模块发起微信支付：
```js
import Wxpay from './your/path/to/Wxpay';
async pay(params){ // params 为后端提供的参数
    let isSupported = await call(Payway.isSupported);
    if (!isSupported) { // 判断是否支持微信支付
        message.show('找不到微信应用，请安装最新版微信');
        return;
    }
    let res = await call(getOrderInfo, params); // 从后端获取签名对象，参考支付接口调用
    let ret = await call(Wxpay.pay, res.data); // 调起微信客户端，发起支付
    if (ret.errCode === 0) {
        // 支付成功回调
    } else {
        // 支付失败回调
    }
}    
```
4. 支付接口调用参考[调起支付接口](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12)和[统一下单](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)，本篇将不做赘述。

## 参考文档
- [APP端开发步骤](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5)
- [Android调用原生模块](http://reactnative.cn/docs/0.50/native-modules-android.html)
- [iOS调用原生模块](http://reactnative.cn/docs/0.50/native-modules-ios.html)
