# 两种控制模式

游戏循环面临着状态的维持和切换，我观察到大概有两种模式。

## 状态变量

用整数或者枚举来记录当前状态。如一个游戏可能这样实现界面控制：

```java
int state = 0;
void everyFrame() {
	switch (state) {
    case 0: // Main Menu
        ...
        if (user click Play)
        	state = 1;
        break;
	case 1: // Game Mode
    	...
    case 2: // Game Over
    	...
    case 3: // High Score
    	...
    }
}
```

复杂的游戏一般有子状态，这时它就是在使用一课状态树。每层状态都需要至少一个变量来保存。

如下图是任天堂超级玛丽状态树的一部分。

游戏内部使用了多个变量，存储当前第几层是第几个状态，游戏根据它们从树根追到要执行的代码。

```
+ OperModeExecutionTree
	+ TitleScreenMode
	+ GameMode
		+ ScreenRoutines
		+ PlayerCtrlRoutine
			+ OnGroundStateSub
			+ JumpSwimSub
			+ FallingSub
			+ ClimbingSub
	+ VictoryMode
	+ GameOverMode
```

请根据英文自行推测其含义。:)

### 关于如何实现的题外话

用C/C++语言实现时，为避免多次的IF判断，有人自建function table：

```cpp
void state_1(void) { ... }
void state_2(void) { ... }
typedef void (*StateFunc)(void);
StateFunc states[] = { state_1, state_2 };
int curState = 0;
void gameloop()
{
	while (curState >= 0) {
    	states[curState]();
    }
}
```

也有人利用class的多态：

```cpp
class State
{
public:
	virtual void update();
};

class State1
{
public:
	virtual void update() { /* implementation */ }
};

class State2
{
public:
	virtual void update() { /*implementation */ }
};

State *curState = NULL;

void gameloop()
{
	while (curState) {
    	curState->update();
    }
}
```

然而，没有这样做的必要。

- 多次的IF判断并不会显著影响速度，尤其对现代计算机
- 现代编译器有能力将switch转换为jump table执行
- 不把每个状态都封装成函数或类有利于控制程序规模

### 弊端

状态之间会共享代码。如超级玛丽里玩家在地面行走和跳跃状态下，都需要水平位置的更新。你会想把它们重构成子程序（函数）。

## 标志变量

另一种方式是，把所有要执行的代码写在一起，用标志变量控制某段代码是否要被执行。

```java
boolean menuMode = true;
boolean powerMode = false;
void everyFrame() {
	if (menuMode) {
    	/* menu logic */
        ...
        if (user click Play)
        	menuMode = false;
    }
    if (!menuMode && powerMode) {
    	/* power mode logic */
    }
    if (!menuMode) {
    	/* game play logic */
        if (player press X key)
        	powerMode = true;
        if (player press Esc)
        	menuMode = true;
    }
}
```

这种方式有一种代码块之间在争夺、转交和接管控制权的意味，这正是它的一种应用。

在任天堂超级玛丽中，玩家一旦踩上弹簧，就会开始“特写镜头”，玩家的纵向移动完全由弹簧控制的代码接管。如下面的伪代码所示：

```java
boolean jumpSpringAnimCtrl = false;
void everyFrame() {
	if (!jumpSpringAnimCtrl) {
    	playerY += playerYSpd;
    }
    ...
    if (player collides with jump spring)
    	jumpSpringAnimCtrl = true;
    ...
    if (jumpSpringAnimCtrl) {
    	playerY += 2;
    }
}
```

对于DOOM这样的游戏，菜单模式下玩家按方向键切换菜单项，菜单下面的演示动画则由演示数据指导。进入游戏后，玩家可以用方向键移动。这也是这种方式的一个应用实例。

## 实际使用

实际开发中两种模式会结合使用。一般用状态变量组织大的状态，在大状态内部使用标志变量控制。可以把使用某一种模式的代码转为使用另一种模式，使用哪种是设计上的选择。
