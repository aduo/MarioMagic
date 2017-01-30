final int boxX = 180, boxY = 300;
final int groundY = 360;
final int boxSize = 20, boxHalfSize = boxSize / 2;
int playerX, playerY = 340;

int state = 0;
boolean prevMousePressed = false;

void setup() {
  size(400, 400);
}

void draw() {
  background(80, 128, 255);
  
  boolean mouseDown = !prevMousePressed && mousePressed;
  String text = "";
  
  switch (state) {
  case 0:
    playerX = mouseX - boxHalfSize;
    text = "click to launch";
    if (mouseDown)
      state = 1;
    break;
  case 1:
    text = "";
    playerY--;
    if (playerY < boxY + boxSize) {
      if (playerX >= boxX - boxSize && playerX <= boxX + boxSize) {
        if (playerX < boxX) {
          playerX--;
        } else {
          playerX++;
        }
      }
      if (playerY + boxSize <= boxY - boxHalfSize)
        state = 2;
    }
    break;
  case 2:
    text = "click to restart";
    if (mouseDown) {
      state = 0;
      playerY = groundY - boxSize;
      playerX = mouseX - boxHalfSize;
    }
    break;
  }
  
  prevMousePressed = mousePressed;
  
  noStroke();
  fill(192, 112, 0);
  rect(0, groundY, width, height - groundY);
  
  stroke(0);
  fill(192, 112, 0);
  rect(boxX, boxY, boxSize, boxSize);
  
  fill(255);
  rect(playerX, playerY, boxSize, boxSize);
  
  textAlign(CENTER);
  textSize(20);
  text(text, 200, 20);
}