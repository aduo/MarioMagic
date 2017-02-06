// a modern implementation could use the Command/Interpreter pattern

final int BREAK = 0;
final int GOTO = 1;
final int PLAN = 2;
final int LOOP = 3;
final int MOVEUP = 6;
final int MOVEDN = 7;
final int DELAY = 9;

final byte[] spiderCode = {
  9,30,
  
  9,4,
  2,2,  0,   6,1,  3,
  2,4,       6,1,  3,
  2,26,      6,2,  3,
  2,4,       6,1,  3,
  2,2,  0,   6,1,  3,
  9,4,
  
  9,4,
  2,2,  0,   7,1,  3,
  2,4,       7,1,  3,
  2,26,      7,2,  3,
  2,4,       7,1,  3,
  2,2,  0,   7,1,  3,
  9,4,
  
  1,2
};

int spiderX = 100;
int spiderY = 100;
int spiderPC = 0; // program counter
int spiderLoopPC = 0;
int spiderTimer = 0;
int spiderFramesLeft;

void setup() {
  size(400,300);
  ellipseMode(RADIUS);
}

void draw() {
  do {
    int cmd = spiderCode[spiderPC];
    int arg1 = spiderCode[spiderPC+1];
    
    switch (cmd) {
    case BREAK:
      spiderPC++;
      spiderTimer = 0;
      break;
    case GOTO:
      spiderPC = arg1;
      continue;
    case PLAN:
      spiderFramesLeft = arg1;
      spiderPC += 2;
      spiderLoopPC = spiderPC;
      continue;
    case LOOP:
      if (--spiderFramesLeft == 0) {
        spiderLoopPC = 0;
        spiderPC++;
      } else {
        spiderPC = spiderLoopPC;
      }
      continue;
    case MOVEUP:
      spiderY -= arg1;
      spiderPC += 2;
      spiderTimer = 0;
      break;
    case MOVEDN:
      spiderY += arg1;
      spiderPC += 2;
      spiderTimer = 0;
      break;
    case DELAY:
      if (++spiderTimer >= arg1) {
        spiderPC += 2;
        spiderTimer = 0;
      }
      break;
    }
  } while(false);
  
  //println(spiderPC + "/" + (spiderCode.length-1));
  
  background(59, 187, 251);
  scale(2.0);
  
  stroke(0);
  line(spiderX, 10, spiderX, 130);
  
  stroke(64, 51, 13);
  fill(239, 111, 89);
  ellipse(spiderX, spiderY, 5, 5);
}