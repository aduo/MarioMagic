# 游戏循环

```java
while (running) {
	beginTime = getTime();

	// 处理操作系统的事件or消息
	handleEvents();

    // 更新游戏对象的状态
    update();

    // 绘制此帧画面
	render();

    // 等待一定时间以保持帧率
    endTime = getTime();
    delayMillis(1000 / FPS - (endTime - beginTime));
}
```

## 使用Win32 API的游戏循环

## Processing中的游戏循环
