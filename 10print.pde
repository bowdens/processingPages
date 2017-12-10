color bgc = color(51);
color lineC = color(255-51);
int x = 0, y = 0;
int w = 800, h = 600;
int s = 30;
int weight = 1; //floor(s/1.45);
float rightChance = 0.5;
float halfChance = 0;

void setup(){
  size(800,600);
  background(bgc);
  draw_maze();
}

void draw_maze(){
  //println("in draw_maze, s = " + s);
  background(bgc);
  while(true){
    //println("drawing line from x = " + x + ", y = " + y + ", with s = " + s + ".");
    draw_line(random(0,1) <= rightChance, x, y, s);
    x += s;
    if(x >= w){
      x = 0;
      y += s;
    }
    if(y >= h){
      y = 0;
      break;
    }
  }
}

void draw_box(int x, int y, int si){
  //fill(bgc);
  //noStroke();
  stroke(bgc);
  strokeWeight(weight+1);
  line(x,y,x+si,y+si);
  line(x,y+si,x+si,y);
}

void draw_line(boolean _line, int x, int y, int si){
  //draw_box(x,y,si);
  
  stroke(lineC);
  strokeWeight(weight);
  if(_line){
    if(random(0,1) < 1 - halfChance){
      line(x,y,x+si,y+si);
    }else{
      line(x,y,x+si/2,y+si/2);
    }
  }else{
    if(random(0,1) < 1 - halfChance){
      line(x, y+si, x+si, y);
    }else{
      line(x+si/2,y+si/2,x,y+si);
    }
    
  }
}

void mousePressed(){
  if(mouseX >= 0 && mouseX <= w && mouseY >= 0 && mouseY <= h) draw_maze();
}

void draw(){
}

color hexToColour(String c){
  //converts a string in the format #123456 to a color
  if(c.length() != 7) return color(0);
  String red = concat(c.charAt(1), c.charAt(2));
  String green = concat(c.charAt(3), c.charAt(4));
  String blue = concat(c.charAt(5), c.charAt(6));
  return color(unhex(c.substring(1,3)), unhex(c.substring(3,5)), unhex(c.substring(5,7)));
}

void changeBGC(String c){
  bgc = hexToColour(c);
}

void changeLineC(String c){
  lineC = hexToColour(c);
}

void changeSize(int sz){
  s = (int)sz;
}

void changeHalfChance(int hc){
  int _halfChance = (int)hc;
  halfChance = _halfChance/100.0;
}

void changeWeight(int we){
  weight = (int)we;
}
