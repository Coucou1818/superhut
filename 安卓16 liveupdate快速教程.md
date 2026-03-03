前言
在当前已公布的Android 16版本中新增了一系列的功能特性和API，如：

动态壁纸的内容处理，提供新的 content API
预测性返回更新，添加了finishAndRemoveTaskCallback() 和 moveTaskToBackCallback等API
健康数据共享更新，添加了ACTIVITY_INTENSITY新数据类型
在 ApplicationStartInfo 中启动组件，添加了 getStartComponent()，用于区分触发启动的组件类型
引入了以进度为中心的Notification.ProgressStyle类型通知，帮助用户顺畅地跟踪用户发起的端到端历程
...

本次我们主要来看Notification.ProgressStyle这种新类型的通知。
什么是有进度的通知？
先来看一张官方的图片。

此时你可能冷嘲热讽：这不就是下载进度的样式吗？不早就有了吗？使用builder.setProgress两秒钟搞定。
不，builder.setProgress 只能设置一个数值，而Notification.ProgressStyle是通知中心新增的全新类型，功能也更加丰富。
我们可以用在共享车辆、导航、快递距离以及 任务完成度等场景中，而之前如果想实现这种功能就只能通过自定义通知的View来解决。
通知模板
Notification.ProgressStyle通知类型模板如下图所示：

各参数含义如下图所示：

参数定义A背景图标。一般为App图标
B头部标题，一般为App名称
C通知时间，一般为系统生成
D通知标题
E通知内容
F进度条
G操作按钮
我们还可以给进度条设置一个图标，如导航按钮或者小汽车图标，如下图所示：

代码实践
比如，我们现在创建一个带有进度的通知样式，代码如下所示：

var progressStyle = if (Build.VERSION.SDK_INT >= 36) {
    Notification.ProgressStyle().setStyledByProgress(false).setProgress(456)
        .setProgressTrackerIcon(Icon.createWithResource(context, R.mipmap.care))
        .setProgressSegments(
            listOf(
                Notification.ProgressStyle.Segment(41).setColor(Color.BLACK),
                Notification.ProgressStyle.Segment(552).setColor(Color.YELLOW),
                Notification.ProgressStyle.Segment(253).setColor(Color.WHITE),
                Notification.ProgressStyle.Segment(94).setColor(Color.BLUE)
            )
        ).setProgressPoints(
            listOf(
                Notification.ProgressStyle.Point(60).setColor(Color.RED),
                Notification.ProgressStyle.Point(560).setColor(Color.GREEN)
            )
        )

然后，我们使用这个progressStyle构建一个通知并发送。


progressStyle?.let {
val builder: Notification.Builder =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(context, "chat1")
                .setSmallIcon(android.R.drawable.ic_dialog_info)
                .setContentTitle("阿黄哥送外卖")
                .setContentText("您的外卖正在配送中")
                .setPriority(Notification.PRIORITY_DEFAULT)
        } else {
            TODO("VERSION.SDK_INT < O")
        }
    it.setBuilder(builder)
    notificationManager?.notify(3, it.build());
} 

运行程序，效果如下图所示。

setProgressPoints用于构建线路中的点，如蓝色和红色的方块，setProgressSegments用于构建线路中的路线。
setProgress用于设置当前位置，当前位置会计算在点和路线的总距离内。如我们仅设置线路路线长度为500，当前位置为250，则图标会在中间位置。
代码如下所示：

Notification.ProgressStyle().setStyledByProgress(false) .setProgress( 250 )
    .setProgressTrackerIcon(Icon.createWithResource(context, R.mipmap.care))
    .setProgressSegments(
        listOf(
            Notification.ProgressStyle.Segment( 250 ).setColor(Color. GREEN ),
Notification.ProgressStyle.Segment( 250 ).setColor(Color. DKGRAY )
        )
    )

运行程序如下图所示：

最后
有了这个功能，我们可以将导航以及自身的位置实时显示在通知栏中，并且可以通过设置不同的颜色来标记路程的拥堵情况。相信后续地图、外卖软件等会优先使用这个新功能。
而对Android开发者来说，这一重大更新让我们距离送外卖又近了一步！
