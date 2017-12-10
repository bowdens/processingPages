
//POINTS

class Points{
  PVector pos;
  Points next;
  
  Points(PVector _pos){
    pos = _pos;
    next = null;
  }
  
  Points find_last(Points head){
    if(head == null) return null;
    while(head.next != null) head = head.next;
    return head;
  }
  
  Points append_point(Points head, Points appender){
    if(head == null) return appender;
    find_last(head).next = appender;
    return head;
  }
  
  int length_point(){
    int count = 0;
    Points head = this;
    while(head != null){
      head = head.next;
      count ++;
    }
    return count;
  }
}

final int BALL_ONLY = 1;
final int BALL_AND_POINTS = 2;
final int POINTS_ONLY = 3;

class Spline{
  Points points;
  Points head;
  PVector ball;
  PVector lastBall;
  
  color c;
  
  float t;
  
  Spline(Points _points, PVector _ball, color _c){
    points = _points;
    head = points;
    ball = _ball;
    lastBall = new PVector(ball.x,ball.y);
    c = _c;
    t = 0;
  }
  
  float bezier_spline(float t, float x1, float x2, float x3, float x4){
    return pow(1-t,3) * x1 + 3 * pow(1-t,2) * t * x2 + 3 * (1-t) * pow(t,2) * x3 + pow(t,3) * x4;
  }
  
  void update(){
    //println("--old ball--");
    //println(ball);
    //println("old last ball");
    //println(lastBall);
    //println("new last ball");
    //println(lastBall);
    
    float speed = 0.05;
    
    t += speed;
    if(t > 1 + speed) t = 0;
    lastBall.x = ball.x;
    lastBall.y = ball.y;
    PVector[] pts = new PVector[4];
    if(head.length_point() < 4) return;
    points = head;
    for(int i = 0; i < pts.length; i ++){
      //println(i);
      pts[i] = new PVector(points.pos.x, points.pos.y);
      points = points.next;
    }
    points = head;
    ball.x = bezierPoint(pts[0].x,pts[1].x,pts[2].x,pts[3].x,t);
    ball.y = bezierPoint(pts[0].y,pts[1].y,pts[2].y,pts[3].y,t);
    
    if(t == 0){
      lastBall.x = ball.x;
      lastBall.y = ball.y;
      //c = color(int(random(2) > 1) * 255,int(random(2) > 1) * 255,int(random(2) > 1) * 255);
    }
  }
  
  void show(int displayMode){
    fill(c);
    noStroke();
    switch(displayMode){
      case BALL_ONLY:
        stroke(c);
        strokeWeight(80);
        //strokeWeight(map(red(c),0,255,0,5) + map(green(c),0,255,0,5) + map(blue(c),0,255,0,5) + 5);
        //println(ball);
        //println(lastBall);
        line(ball.x, ball.y, lastBall.x,lastBall.y);
        break;
        
      case BALL_AND_POINTS:
        
        show(POINTS_ONLY);
        show(BALL_ONLY);
        break;
        
      case POINTS_ONLY:
        //fill(255);
        fill(c);
        while(points != null){
          ellipse(points.pos.x, points.pos.y, 30,30);
          points = points.next;
        }
        points = head;      
        break;
      default:
        show(BALL_AND_POINTS);
        break;
    }
  }
}

//SPLINEART

Points p;
Spline s[] = new Spline[1000];

int w = 1300, h = 900;

int index = 0;

color bg_colour = color(13*16+7,13*16+7,15*16+7);

void setup(){
  frameRate(60);
  size(1300,900);
  background(bg_colour);
  PVector last;
  PVector first;
  int edge = round(random(3));
  println(edge);
  switch(edge){
    case 0:
      last = new PVector(0, random(h));
      break;
    case 1:
      last = new PVector(w, random(h));
      break;
    case 2:
      last = new PVector(random(w), 0);
      break;
    case 3:
      last = new PVector(random(w), h);
      break;
    default:
      last = new PVector(random(w), 0);
      break;
  }
    
  for(int i = 0; i < s.length; i ++){
    
    first = last;
    /*edge = round(random(3));
    println(edge);
    switch(edge){
      case 0:
        first = new PVector(0, random(h));
        break;
      case 1:
        first = new PVector(w, random(h));
        break;
      case 2:
        first = new PVector(random(w), 0);
        break;
      case 3:
        first = new PVector(random(w), h);
        break;
      default:
        first = new PVector(random(w), 0);
        break;
    }*/
    
    edge = round(random(3));
    println(edge);
    switch(edge){
      case 0:
        last = new PVector(0, random(h));
        break;
      case 1:
        last = new PVector(w, random(h));
        break;
      case 2:
        last = new PVector(random(w), 0);
        break;
      case 3:
        last = new PVector(random(w), h);
        break;
      default:
        last = new PVector(random(w), 0);
        break;
    }
    
    
    p = new Points(first);
    p.next = new Points(new PVector(random(w),random(h)));
    p.next.next = new Points(new PVector(random(w),random(h)));
    p.next.next.next = new Points(last);
    
    s[i] = new Spline(p, new PVector(p.pos.x,p.pos.y), color(random(128,255),random(128,255),random(128,255)));
  }
}

void draw(){
  s[index].update();
  s[index].show(BALL_ONLY);
  if(s[index].t == 0){
    index ++;
    println(index);
  }
  if(index >= s.length){
    index = 0;
    //background(51);
  }
  //println(frameRate);
}

void mousePressed(){
  //background(bg_colour);
}