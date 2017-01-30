# 按键过滤

## 按键缓存

我研究的所有游戏，都是将键是否按下在帧首存储到变量中，而不是需要时再查询。

```java
// 错误的演示1
void draw() {
	if (keyPressed && key == 'z')
    	handle jumping
}
```

```java
// 错误的演示2
void keyPressed() {
	if (key == 'z')
    	handle jumping
}
```

```java
// 推荐的做法
boolean jumpPressed = false;
void handleKey(boolean b) {
	if (key == 'z' || key == 'Z') {
    	jumpPressed = b;
    }
}
void keyPressed() {
	handleKey(true);
}
void keyReleased() {
	handleKey(false);
}

void draw() {
	if (jumpPressed)
    	// handle jumping
}
```

### 实现细节

可以不将按键存储到boolean变量，而是存储到一个bitset中。这正是一些老游戏的做法。

```java
final int KEY_LEFT  = 1;
final int KEY_RIGHT = 2;
final int KEY_JUMP  = 4;
int keypad = 0;

void setKey(int bit, boolean b) {
	if (b)
		keypad |= bit;
    else
    	keypad &= ~bit;
}

boolean isKeyPressed(int bit) {
	return (keypad & bit) == bit;
}

void handleKey(boolean b) {
	if (key == 'z' || key == 'Z')
    	setKey(KEY_JUMP, b);
    ...
}

void draw() {
	if (isKeyPressed(KEY_JUMP))
    	// handle jumping
}
```

## 捕捉上升沿

有时只想在某键刚按下时触发事件，但此键如果一直按下，不重复执行。

（与之相反，按住左/右键，玩家会保持移动）

```java
boolean prevJumpPressed = false;

void everyFrame() {
	if (!prevJumpPressed && jumpPressed) {
		// handle jump
    }
    prevJumpPressed = jumpPressed;
}

```
