---
title: React Native Modal 点击遮罩层关闭
date: 2017-12-01 13:58:11
description: 在开发 ReactNative 程序的时候，经常有这样的需求，弹出一个弹窗窗口，用户需要点击返回键或者点击遮罩层关闭弹窗，以下代码兼容 Android 和 iOS 平台
tags:
  - React
  - ReactNative
categories:
  - Front
---
在开发 ReactNative 程序的时候，经常有这样的需求，弹出一个弹窗窗口，用户需要点击返回键或者点击遮罩层关闭弹窗，以下代码兼容 Android 和 iOS 平台
```jsx
const {width, height} = Dimensions.get('window');
<Modal
    animationType={"slide"}
    transparent={true}
    visible={this.state.modalVisible}
    onRequestClose={() => this.setState({modalVisible:false})}>
    <View style={{width,height,position:'relative'}}>
    <TouchableWithoutFeedback onPress={()=>this.setState({modalVisible:false})}>
        <View  style={{position:'absolute',width,height,top:0,left:0,backgroundColor:'rgba(0,0,0,.5)'}}/>
    </TouchableWithoutFeedback>
    {/*...your code*/}
    </View>
</Modal>
```