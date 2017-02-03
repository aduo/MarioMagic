# 碰撞检测法

我研究的这些马里奥式的游戏，它们使用的碰撞检测方法并不高级，但是颇具技巧性。

## 点在格中

取玩家身体上的点，检查它们对应tile的内容。

```java
int headX = playerX + playerWidth / 2;
int headY = playerY + 2;
int tileMapX = headX / TILE_WIDTH;
int tileMapY = headY / TILE_HEIGHT;
if (tileMap.get(tileMapX, tileMapY) == BLOCK_TILE) {
	// handle player bump block
}
```

任天堂超级玛丽中，玩家身体上有8个点供检测。这些点的坐标可以根据玩家坐标和玩家的大/小计算出。玩家头顶中央有一个点，游戏若检测到此点映射的tile是砖块，就让玩家下落并让砖块弹起或破碎。玩家双脚下各有一个点，游戏若检测到这两点对应的tile都不是地面，就把玩家切换到下落状态。

（图：玛丽身上的点）

这种思路还可以结合位图使用。

```java
int headX = playerX + playerWidth / 2;
int headY = playerY + 2;
if (wallBitmap.getPixel(headX, headY) == COLOR_WALL) {
	// handle player hurt his head
}
```

Flash游戏Fancy Pants Adventure中，地面崎岖不平，用位图表示。玩家双脚下各有两点，游戏根据地面位图中的这两点是否填充，绕左脚或右脚旋转玩家使他紧贴地面。

（图：Pants身上的点）
（图：地面位图）

## AABB

玩家与地面的碰撞检测是动态实体与静态实体之间的。检测两动态实体是否碰撞，此类游戏一般使用AABB碰撞法。

AABB中文全称叫轴对齐包装盒。这种方法本质上是检测两矩形是否有重叠部分。维基百科和《游戏引擎架构》都有对它的介绍。

任天堂超级玛丽用它检测子弹与怪物、玩家与怪物等碰撞。

（图？：子弹与怪物包装盒重叠图）

## 控制实体速度

不可以让实体运动过快。

如果玩家一帧行进的横向距离超过一个tile的尺寸，会让玩家从厚度一格的墙壁中穿过，不会被碰撞检测发现。

如果两个实体一帧相对行进的距离比最大实体的尺寸还大，那么AABB不会检测到碰撞。

是否会发生这种情况，不需要用严格的计算验证。此类游戏大多数实体的运动速度很低，但还是应该注意。

## 区分碰入方向

有些情况下，实体从不同的方向碰入另一实体，处理不同。

有时只需要区分上下或者左右，这种情况下根据实体这一轴向的速度判断即可。比如在任天堂超级玛丽中，检测到玩家与板栗仔[(?)](#)碰撞时，若速度大于等于0，说明是从上向下碰入，让板栗仔被踩扁，给玩家一个向上的纵向速度使之弹起，否则玩家掉血。

更加复杂的情况是四个方向的处理都不同。严格区分两个相邻方向（如上和左）的撞入其实很难，只有误差较小的方案。在任天堂超级玛丽中，玩家从上方碰入运送板时会着陆，从下方碰入时会下落，从左右碰入时则会被弹出。下面是它区分这些情况的逻辑（假定已经通过AABB检测到碰撞）：

（图：运送板）

```java
if (platform.bottom - player.top < 4) {
	// knock from bottom --> let player fall
    player.ySpeed = 1;
} else if (player.bottom - platform.top < 6) {
	// knock from top --> land player
    player.state = ON_GROUND;
} else {
	// knock from left/right --> push player out
    if (player.right - platform.left < 8)
    	impedePlayerMove(1);
    else if (platform.right - player.left < 10) // the condition here is not necessary
    	impedePlayerMove(2);
}
```

我想，如果玩家身上的点够多够均匀，应该也可以通过判断哪些点在运送板的包装盒内来判断。如：头部的点在包装盒内，且多于两侧在包装盒内点的数目，大概可以判定是从下向上碰撞。
