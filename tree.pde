final float rotangleL = PI/8;
final float rotangleR = PI/8;
final float rand = PI/32;
final float minsize = 2;
final float scalingfactor = 0.7;

class Branch {
  PVector start;
  PVector end;
  
  Branch left;
  Branch right;
  
  Branch(PVector _start, PVector _end){
    start = _start;
    end = _end;
    left = null;
    right = null;
  }
  
  Branch copy(){
    Branch b = new Branch(start, end);
    b.left = left==null?null:left.copy();
    b.right = right==null?null:right.copy();
    return b;
  }
  
  void tree(){
    if(round(random(0,10))!=1) branch(true);
    if(round(random(0,10))!=1) branch(false);
    if(left != null) left.tree();
    if(right != null) right.tree();
  }
  
  
  void branch(boolean L){
    PVector point = PVector.sub(end, start);
    float rot = L?-rotangleL+random(-rand,rand):rotangleR + random(-rand,rand);
    point.rotate(rot);
    float sf = (round(random(0,4)) == 0)?random(scalingfactor/4,3*scalingfactor/4):scalingfactor;
    point.mult(sf);
    if(point.mag() < minsize) return;
    PVector n = PVector.add(point, end);
    Branch ret = new Branch(end, n);
    if(L){
      left = ret.copy();
    }else{
      right = ret.copy();
    }
  }
  
  void show(){
    float plen = PVector.sub(end,start).mag();
    strokeWeight(plen/10);
    stroke(110,120,20);
    //println("drawing line from (" + start.x + ", " + start.y + ") to (" + end.x + ", " + end.y + ")");
    line(start.x,start.y,end.x,end.y);
    
    stroke(55,60,10);
    line(start.x+plen/20,start.y+plen/20,end.x+plen/20,end.y+plen/20);
    
    if(left != null) left.show();
    if(right != null) right.show();
    noStroke();
    fill(160+random(-50,20),200+random(0,55),40+random(-40,10));
    int leafsize = 8;
    float leafx = leafsize + random(-2,2);
    float leafy = leafsize + random(-2,2);
    if(left == null && right == null && plen/10 < leafsize){
      if(round(random(0,3)) != 1) ellipse(end.x,end.y,leafx,leafy);
    }
  }

  void pb(){
    println("BRANCH");
    println("this: " + this);
    println("left:    " + left);
    println("right:   " + right);
    println("start:   " + start);
    println("end:     " + end);
  }
}

//CODE

int w = 500, h = 500;
color bgc = color(51,51,51);
float defaultLen = w/5.0;
float randv = random(-defaultLen/5.0,defaultLen/5.0);
float len = defaultLen + randv;
b = new Branch(new PVector(w/2, h), new PVector(w/2, h-len));

void setup(){
  size(500,500);
  background(bgc);
  randv = random(-defaultLen/5.0,defaultLen/5.0);
  len = defaultLen + randv;
  b = new Branch(new PVector(w/2,h), new PVector(w/2, h-len));
  //println("started tree");
  b.tree();
  //println("finished making tree. Drawing tree");
  b.show();
  //println("drawing tree complete");
}

void mousePressed(){
  if(mouseX >= 0 && mouseX <= w && mouseY >= 0 && mouseY <= h) setup(); 
}

color hexToColour(String c){
  if(c.length() != 7) return color(0);
  string red = c.substring(1,3);
  string green = c.substring(3,5);
  string blue = c.substring(5,7);
  return color(unhex(red),unhex(green),unhex(blue));
}

void changeBGColour(string c){
  bgc = hexToColour(c);
  background(bgc);
  b.show();
}

void changeDefaultLen(int l){
    if(l < 0) return;
    defaultLen = round(l);
}

void changeRotangleL(float a){
  rotangleL = a;
}

void changeRotangleR(float a){
  rotangleR = a;
}

void changeAngleRand(float a){
  rand = a;
}

void changeBranchColour(string c){
    color temp = hexToColour(c);
}
