# 游戏循环

游戏代码的总结构是一个循环，这个循环不断更新游戏状态。它的构成如下：

```java
while (running) {
	beginTime = getTime();

	// 处理操作系统的事件or消息
	handleEvents();

    // 读取按键、鼠标或游戏手柄的输入
    readJoypad();

    // 更新游戏对象的状态
    update();

    // 绘制此帧画面
	render();

    // 等待一定时间以保持帧率
    endTime = getTime();
    delayMillis(1000 / FPS - (endTime - beginTime));
}
```

## Processing中的游戏循环

Processing内部已经帮我们实现了游戏循环，这个循环更新游戏对象和绘制此帧画面的的部分由draw()承包。开发者通过编写draw()来定制它们。

Processing提供了内置的保持帧率的机制，连续两次调用draw()相隔的时间不会有明显变化。可以在setup()中使用frameRate(FPS)函数设置帧率（默认为60）。还有一个变量frameCount存储当前帧数，在区分不同帧之间的日志输出时很有用。

在Processing中可以通过变量mousePressed、mouseX和mouseY读取鼠标状态。键盘按键可以通过变量key和keyCode读取，但它们不会在按键松开时清零，也不能检测多个键同时按下，这些问题可以通过编写keyPressed()和keyReleased()处理函数解决，参见*按键过滤*。
