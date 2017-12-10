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
    
    t += 0.006;
    if(t > 1) t = 0;
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

