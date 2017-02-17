# AoS与SoA存储

AoS(Array of Structs)和SoA(Struct of Arrays)是存储结构体数组的两种方式。

如果游戏需要一块内存存储所有敌人的状态，AoS会这样存储：

```cpp
// C++
struct Enemy
{
	int state;
	int x;
    int y;
};

Enemy allEnemies[MAX_ENEMIES];
```

SoA则会：

```cpp
// C++
struct Enemies
{
	int state[MAX_ENEMIES];
    int x[MAX_ENEMIES];
    int y[MAX_ENEMIES];
};

Enemies allEnemies;
```

甚至不需要结构体定义：

```cpp
// C++
int enemy_state[MAX_ENEMIES];
int enemy_x[MAX_ENEMIES];
int enemy_y[MAX_ENEMIES];
```

同样是访问第2个敌人的y坐标：

```cpp
AoS: allEnemies[1].x
SoA: allEnemies.x[1]或enemy_x[1]
```

使用SoA存储，数据的访问与结构体的长度无关。结构体加减成员不会影响其他成员的存储，随机访问时（指通过下标i）省去了乘法操作。（因为需要用<code>i*sizeof(struct Xxx)</code>来计算地址）这些都非常适合FC使用的6502（这种CPU芯片连乘法指令都没有）。

SoA放在现代游戏中使用也不过时。它有一个好处：可以降低数据结构的维度。

Flash游戏Fancy Pants Adventure使用它存储怪物信息：

```javascript
Level1BadName = ["Spider", "Spider", "Spider", "Spider", "Spider", "Spider", "Spider", "Mouse"];
Level1BaddieX = [665.7, 895, 2750, 3275, 4880, 4780, 4680, 7303];
Level1BaddieY = [0, 0, 20, -590, -280, -280, -280, -1270];
```
