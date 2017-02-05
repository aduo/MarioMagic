int state = 0;
boolean prevMousePressed = false;

int fireBallX;
int fireBallY;
int fireBallState;
int fireBallYSpeed;
int fireBallColor;
int fireBallRadius, fireBallSubRadius;

final int initFBX = 100;
final int initFBY = 270;
final int fireBallXSpeed = 10;
final int fireBallBounceUpSpeed = -10;
final int gravity = 1;

final int wallX = 750;
final int groundY = 352;

void initFireBall() {
  fireBallX = initFBX;
  fireBallY = initFBY;
  fireBallState = 0;
  fireBallYSpeed = 0;
  fireBallColor = 0;
  fireBallRadius = 8;
  fireBallSubRadius = 0;
}

void setup() {
  size(800, 400);
  ellipseMode(RADIUS);
  
  initFireBall();
}

void draw() {
  background(80, 128, 255);
  
  boolean mouseClicked = false;
  if (!prevMousePressed && mousePressed)
    mouseClicked = true;
  prevMousePressed = mousePressed;
  
  String prompt = "";
  
  // update fireball
  if (state == 0) {
    if (mouseClicked) {
      state = 1;
    }
    prompt = "click to fire";
  } else if (state == 1) {
    if (fireBallState == 0) {
      fireBallX += fireBallXSpeed;
      fireBallY += fireBallYSpeed;
      fireBallYSpeed += gravity;
  
      if (fireBallY + fireBallRadius > groundY) {
        fireBallYSpeed = fireBallBounceUpSpeed;
      }
      
      if (fireBallX + fireBallRadius > wallX) {
        fireBallState = 1;
      }
    } else {
      fireBallColor += 2;
      if (++fireBallSubRadius >= 3) {
        fireBallSubRadius = 0;
        fireBallRadius += 1;
      }
      if (fireBallColor >= 127) {
        state = 2;
      }
    }
  } else if (state == 2) {
    if (mouseClicked) {
      initFireBall();
      state = 0;
    }
    prompt = "click to reset";
  }
  
  // draw ground
  noStroke();
  fill(192, 112, 0);
  rect(0, groundY, width, 16);
  
  // draw pipe
  noStroke();
  fill(72, 168, 16);
  rect(wallX, 0, 32, groundY);
  fill(152, 232, 0);
  rect(wallX+5, 0, 8, groundY);
  
  // draw fire ball
  stroke(0);
  fill(255, fireBallColor, 0);
  ellipse(fireBallX, fireBallY, fireBallRadius, fireBallRadius);
  
  // draw text
  fill(255);
  textAlign(CENTER);
  textSize(20);
  text(prompt, width/2, 20);
}