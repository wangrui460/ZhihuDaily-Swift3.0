# ZhihuDaily-Swift3.0
为了让我的另一个库WRNetWrapper使用起来更高效，特开此项目作为测试，代码从0开始

[知乎日报 API 分析](https://github.com/izzyleung/ZhihuDailyPurify/wiki/知乎日报-API-分析)

# 日志
#### **1.  2017.05.06**
- 完成启动页闪屏展示

**注意：**  
- 因为知乎素材并没有LaunchImage图片，所以我就用了自己App的启动图片。  
- 对喵神的 Kingfisher 修改了一下，解决了当placeholder为nil的时候，如果原图片框中已有图片，则会闪一下的问题  
修改后的代码  https://github.com/wangrui460/Kingfisher

---

#### **2.  2017.05.07**
- 重构网络部分代码

**注意：**  
- 以后所有网络请求都要放在 WRApiContainer 中。好处是所有网络请求一目了然、修改起来非常容易、类方法快速直接调用，基本不需要传什么参数！

--- 

#### **3.  2017.05.08**
- 完成版本更新检查

**注意：**  
- 因为不知道知乎日报的appid，所以点击前往后就跳到AppStore的首页


--- 

#### **4.  2017.05.09**
- 添加接口最新消息
- 启动页闪屏右上方添加跳过按钮，并添加点击事件

**注意：**  
- 用runtime写了一个UIView的分类，处理所有继承UIView的轻点事件  
- 把按钮添加在图片上，必须要设置图片isUserInteractionEnabled等于true，这样按钮才具有轻点事件

---
