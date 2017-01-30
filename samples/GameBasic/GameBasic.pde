class GameObj
{
  public boolean occupied;
  public int x, y;
  public int score;
  public int timer;
}

GameObj[] objList = new GameObj[20];
final int[] scoreTable = new int[] { 100, 200, 500, 1000 };
boolean prevMousePressed = false;

int findFreeSlot()
{
  for (int i = 0; i < objList.length; i++)
    if (!objList[i].occupied)
      return i;
  return -1;
}

void spawnObj(int x, int y, int score)
{
  int i = findFreeSlot();
  if (i < 0)
    return;
  objList[i].occupied = true;
  objList[i].x = x;
  objList[i].y = y;
  objList[i].score = score;
  objList[i].timer = 100;
}

void update() {
  for (int i = 0; i < objList.length; i++) {
    if (!objList[i].occupied)
      continue;
    if (--objList[i].timer <= 0) {
      objList[i].occupied = false;
      continue;
    }
    objList[i].y--;
    if (objList[i].y < 0) {
      objList[i].occupied = false;
    }
  }
  
  if (!prevMousePressed && mousePressed) {
    int score = scoreTable[(int) random(scoreTable.length)];
    spawnObj(mouseX, mouseY, score);
  }
  prevMousePressed = mousePressed;
}

void draw() {
  background(60, 188, 252);
  
  update();
  
  for (int i = 0; i < objList.length; i++) {
    if (!objList[i].occupied)
      continue;
    text(Integer.toString(objList[i].score), objList[i].x, objList[i].y);
  }
}

void setup() {
  size(400, 400);
  
  textSize(20);
  textAlign(CENTER);
  
  for (int i = 0; i < objList.length; i++) {
    objList[i] = new GameObj();
    objList[i].occupied = false;
  }
}