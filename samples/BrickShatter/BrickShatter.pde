class Entity
{
  boolean alive = false;
  int type;
  int x, y;
  int xSpeed, ySpeed;

  void init(int _type, int _x, int _y) {
    this.init(_type, _x, _y, 0, 0);
  }
  
  void init(int _type, int _x, int _y, int _xSpeed, int _ySpeed) {
    alive = true;
    type = _type;
    x = _x;
    y = _y;
    xSpeed = _xSpeed;
    ySpeed = _ySpeed << 8;
  }
}

Entity[] world;
Entity bigBrick;

final int brickSize = 32;
final int chunkSize = 16;
int chunkLeft = 0;
int waitTimer = 0;

boolean prevMousePressed = false;

void initBigBrick() {
  bigBrick.init(0, (width - brickSize) / 2, 100);
}

void shatter() {
  bigBrick.alive = false;

  int w, h;
  w = h = chunkSize;
  world[1].init(1, bigBrick.x, bigBrick.y, -1, -6);
  world[2].init(1, bigBrick.x + w, bigBrick.y, 1, -6);
  world[3].init(1, bigBrick.x, bigBrick.y + h, -1, -4);
  world[4].init(1, bigBrick.x + w, bigBrick.y + h, 1, -4);
  chunkLeft = 4; 
}

void draw() {
  boolean mouseClicked = (!prevMousePressed && mousePressed);
  prevMousePressed = mousePressed;

  if (bigBrick.alive && mouseClicked)
    shatter();
  
  for (Entity e : world) {
    if (!e.alive)
      continue;
    
    if (e.type == 1) {
      e.x += e.xSpeed;
      e.y += e.ySpeed >> 8;
      e.ySpeed = min(8 << 8, e.ySpeed + 80);
      
      if (e.x + chunkSize <= 0 || e.x >= width || e.y >= height) {
        e.alive = false;
        chunkLeft--;
      }
    }
  }
  
  if (!bigBrick.alive && chunkLeft == 0) {
    if (++waitTimer == 10) {
      waitTimer = 0;
      initBigBrick();
    }
  }
  
  String prompt = "";
  if (bigBrick.alive)
    prompt = "click to shatter";

  background(92, 148, 252);

  fill(255);
  textAlign(CENTER);
  textSize(20);
  text(prompt, width/2, 20);

  fill(200, 76, 12);
  for (Entity e : world) {
    if (!e.alive)
      continue;
    
    if (e.type == 0) {
      rect(e.x, e.y, brickSize, brickSize);
    } else if (e.type == 1) {
      pushMatrix();
      translate(e.x + chunkSize / 2, e.y + chunkSize / 2);
      // original SuperMarioBros doesn't use rotation
      // but really use flipping to simulate it
      int angle = 30;
      if ((frameCount & 8) == 8) // vertical flip
        angle = 180 - angle;
      if ((frameCount & 4) == 4) // horizontal flip
        angle = -angle;
      rotate(radians(angle));
      rect(-chunkSize / 2, -chunkSize / 2, chunkSize, chunkSize);
      popMatrix();
    }
    
  }
}

void setup() {
  size(400, 400);
  
  world = new Entity[5];
  for (int i = 0; i < world.length; i++)
    world[i] = new Entity();

  bigBrick = world[0];

  initBigBrick();
}