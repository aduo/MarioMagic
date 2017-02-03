class TwoByteInt {
  short val;
  
  void init(int n) {
    this.val = (short) n;
  }
  
  int get() {
    return val >> 8;
  }
  
  void add(TwoByteInt o) {
    this.val += o.val;
  }
}

class Coord {
  int x, y;
  
  Coord(int x_, int y_) {
    x = x_;
    y = y_;
  }
}

Coord[] coords = new Coord[] {
  new Coord(20, 60),
  new Coord(40, 40),
  new Coord(80, 80),
  new Coord(100, 20)
};
int numPairs;
TwoByteInt manX = new TwoByteInt(), manY = new TwoByteInt();
TwoByteInt incX = new TwoByteInt(), incY = new TwoByteInt();
boolean inversed;
int curIndex, nextIndex;

void setup() {
  size(180, 180);
  ellipseMode(RADIUS);
  
  numPairs = coords.length - 1;
  manX.init(coords[0].x << 8);
  manY.init(coords[0].y << 8);
  inversed = false;
  curIndex = -1;

  loadNext();
}

void loadNext() {
  if (!inversed) {
    if (++curIndex == numPairs)
      inversed = true;
  } else {
    if (--curIndex == 0)
      inversed = false;
  }
  nextIndex = inversed ? curIndex - 1 : curIndex + 1;

  Coord c1 = coords[curIndex];
  Coord c2 = coords[nextIndex]; 
  incX.init((c2.x - c1.x) << 1); // == x difference / 128
  incY.init((c2.y - c1.y) << 1);
}

void draw() {
  background(192);
  
  for (int i = 0; i < numPairs; i++) {
    Coord a = coords[i];
    Coord b = coords[i + 1];
    line(a.x, a.y, b.x, b.y);
  }
  
  ellipse(manX.get(), manY.get(), 5, 5);
  
  manX.add(incX);
  manY.add(incY);
  
  Coord nextCoord = coords[nextIndex];
  if (manX.get() == nextCoord.x && manY.get() == nextCoord.y) {
    loadNext();
  }
}