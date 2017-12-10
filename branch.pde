final float rotangle = PI/8;
final float rand = PI/16;
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
    float rot = L?-rotangle:rotangle + random(-rand,rand);
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
    float len = PVector.sub(end,start).mag();
    strokeWeight(len/10);
    stroke(110,120,20);
    line(start.x,start.y,end.x,end.y);
    
    stroke(55,60,10);
    line(start.x+len/20,start.y+len/20,end.x+len/20,end.y+len/20);
    
    if(left != null) left.show();
    if(right != null) right.show();
    noStroke();
    fill(160+random(-50,20),200+random(0,55),40+random(-40,10));
    int leafsize = 8;
    float leafx = leafsize + random(-2,2);
    float leafy = leafsize + random(-2,2);
    if(left == null && right == null && len/10 < leafsize){
      if(round(random(0,3)) != 1) ellipse(end.x,end.y,leafx,leafy);
    }
  }
}

