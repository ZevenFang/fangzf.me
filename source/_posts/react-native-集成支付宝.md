---
title: react-native 集成支付宝
date: 2017-12-05 09:40:59
description: 现在很多 APP 都有集成第三方支付平台的需求，用来支付自己的产品，但是官方一般都没有介绍如何集成到 react-native 的应用中，本篇文章将基于官方提供的集成文档，介绍如何将支付宝集成到 react-native 应用中。
tags:
  - React
  - ReactNative
categories:
  - Front
---
现在很多 APP 都有集成第三方支付平台的需求，用来支付自己的产品，但是官方一般都没有介绍如何集成到 react-native 的应用中，本篇文章将基于官方提供的集成文档，介绍如何将支付宝集成到 react-native 应用中。

## 场景介绍
>适用于商家在App应用中集成支付宝支付功能。
商家APP调用支付宝提供的SDK，SDK再调用支付宝APP内的支付模块。如果用户已安装支付宝APP，商家APP会跳转到支付宝中完成支付，支付完后跳回到商家APP内，最后展示支付结果。如果用户没有安装支付宝APP，商家APP内会调起支付宝网页支付收银台，用户登录支付宝账户，支付完后展示支付结果。
目前支持手机系统有：iOS（苹果）、Android（安卓）。

## 集成SDK
### Android
1. 将alipaySdk-xxxxxxxx.jar包放入`android/app/libs`目录下，如下图。
![](https://gw.alipayobjects.com/zos/skylark/public/files/909cb3a6c0febb5ef77be00e8cbfcdfe.png)
2. 将libs目录下的alipaySDK-xxxxxxxx.jar导入，在`android/app/build.gradle`里添加如下代码：
```js
dependencies {
    ......
    compile files('libs/alipaySdk-20170725.jar')
    ......
}
```
3. 在`android/app/src/AndroidManifest.xml`文件里面添加声明：
```xml
<!-- 支付宝 activity 声明 -->
<activity
    android:name="com.alipay.sdk.app.H5PayActivity"
    android:configChanges="orientation|keyboardHidden|navigation|screenSize"
    android:exported="false"
    android:screenOrientation="behind"
    android:windowSoftInputMode="adjustResize|stateHidden" >
</activity>
<activity
    android:name="com.alipay.sdk.app.H5AuthActivity"
    android:configChanges="orientation|keyboardHidden|navigation"
    android:exported="false"
    android:screenOrientation="behind"
    android:windowSoftInputMode="adjustResize|stateHidden" >
</activity>
<!-- 支付宝权限声明 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```
4. 在`android/app/proguard-rules.pro`添加混淆规则
```js
-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}
-keep class com.alipay.sdk.app.H5PayCallback {
    <fields>;
    <methods>;
}
-keep class com.alipay.android.phone.mrpc.core.** { *; }
-keep class com.alipay.apmobilesecuritysdk.** { *; }
-keep class com.alipay.mobile.framework.service.annotation.** { *; }
-keep class com.alipay.mobilesecuritysdk.face.** { *; }
-keep class com.alipay.tscenter.biz.rpc.** { *; }
-keep class org.json.alipay.** { *; }
-keep class com.alipay.tscenter.** { *; }
-keep class com.ta.utdid2.** { *;}
-keep class com.ut.device.** { *;}
```
5. 在`com.xx.xx`创建包名`alipay`
6. 编写 Module，在`com.xx.xx.alipay`包下创建`AlipayModule.java`，代码如下：
```java
package com.xx.xx.alipay;

import com.alipay.sdk.app.PayTask;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import java.util.Map;

public class AlipayModule extends ReactContextBaseJavaModule {

  public AlipayModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "Alipay";
  }

  @ReactMethod
  public void pay(final String orderInfo, final Promise promise) {
    Runnable payRunnable = new Runnable() {
      @Override
      public void run() {
        WritableMap map = Arguments.createMap();
        PayTask alipay = new PayTask(getCurrentActivity());
        Map<String, String> result = alipay.payV2(orderInfo,true);
        for (Map.Entry<String, String> entry: result.entrySet())
          map.putString(entry.getKey(), entry.getValue());
        promise.resolve(map);
      }
    };
    // 必须异步调用
    Thread payThread = new Thread(payRunnable);
    payThread.start();
  }

}
```
7. 编写 Package，在`com.xx.xx.alipay`包下创建`AlipayPackage.java`，代码如下：
```java
package com.xx.xx.alipay;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class AlipayPackage implements ReactPackage {

  @Override
  public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
    return Collections.emptyList();
  }

  @Override
  public List<NativeModule> createNativeModules(
          ReactApplicationContext reactContext) {
    List<NativeModule> modules = new ArrayList<>();
    modules.add(new AlipayModule(reactContext));
    return modules;
  }

}
```
8. 最后在 Android 这边要做的最后一件事就是注册这个模块，在`com.xx.xx.MainApplication`中注册模块：
```java
@Override
protected List<ReactPackage> getPackages() {
    return Arrays.<ReactPackage>asList(
        new MainReactPackage(),
        // ...other packages
        new AlipayPackage() // <-- 注册模块
    );
}
```

### iOS
1. 启动IDE（如Xcode），把[iOS包](https://docs.open.alipay.com/54/104509)中的压缩文件中以下文件拷贝到项目文件夹下，并导入到项目工程中。
AlipaySDK.bundle
AlipaySDK.framework
2. 在Build Phases选项卡的Link Binary With Libraries中，增加以下依赖：
![](https://gw.alipayobjects.com/os/skylark/public/files/3ebefcabdf8062f717dbb5d866ba7cfb)
  - 如果是Xcode 7.0之后的版本，需要添加libc++.tbd、libz.tbd；
  - 如果是Xcode 7.0之前的版本，需要添加libc++.dylib、libz.dylib。
3. 在项目目录下创建Group `Alipay`，并创建`AlipayMoudle`模块，如下图所示：
![2017-12-05-16-24-34](http://p0gxdxnc4.bkt.clouddn.com/2017-12-05-16-24-34.png)
4. 编写`AlipayModule.h`代码如下：

  ```objc
  #import <React/RCTBridgeModule.h>
  #import <React/RCTLog.h>

  @interface AlipayMoudle : NSObject <RCTBridgeModule>
  @end
  ```
5. 编写`AlipayModule.m`代码如下：
  
  ```objc
  #import "AlipayMoudle.h"
  #import <AlipaySDK/AlipaySDK.h>

  @implementation AlipayMoudle

  RCT_EXPORT_METHOD(pay:(NSString *)orderInfo
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject){
    //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
      resolve(resultDic);
    }];
  }

  RCT_EXPORT_MODULE(Alipay);

  @end
  ```
6. 至此，iOS端支付宝SDK集成成功

### React-Native
1. 修改原生代码后，需要重新打包运行程序：
```shell
react-native run-android # 运行Android端
react-native run-ios # 运行iOS端
```
2. 编写`Alipay.js`工具类
```js
import { NativeModules } from 'react-native';
export default NativeModules.Alipay;
```
3. 调用`Alipay`模块发起支付宝支付：
```js
import Alipay from './your/path/to/Alipay';
async pay(params){ // params 为后端提供的参数
  let res = await call(getOrderInfo, params); // 从后端获取签名字串，参考支付接口调用
  let ret = await call(Alipay.pay, res.data); // 调起支付宝，发起支付
  if (ret.resultStatus === '9000') {
    // 支付成功回调
  } else {
    // 支付失败回调
  }
}
```
4. 支付接口调用参考[支付接口调用](https://docs.open.alipay.com/204/105296/#s3)和[支付请求参数说明](https://docs.open.alipay.com/204/105465/)，本篇将不做赘述。

### 后记
后面会继续介绍 react-native 微信支付的集成，相比支付宝集成，微信支付集成会麻烦很多，比如处理回调、应用签名机制、注册scheme等都提高了集成的复杂度。

## 参考文档
- [App支付Android集成流程](https://docs.open.alipay.com/204/105296/)
- [App支付iOS集成流程](https://docs.open.alipay.com/204/105295/)
- [Android调用原生模块](http://reactnative.cn/docs/0.50/native-modules-android.html)
- [iOS调用原生模块](http://reactnative.cn/docs/0.50/native-modules-ios.html)
