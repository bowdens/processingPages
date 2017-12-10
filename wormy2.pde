color dotcolor = color(192,128,64);

int RAND_SIZE = 8;
float RAND_LIM = 2;
float rand[] = {0,0,0,0,0,0,0,0};
float dampening = 0.01;

int drawmode = 0;

int w = 500, h = 500;

float calc_acc(float a, float b, float c, float d, float xpos, float ypos, float w, float h){
  return a * cos(a * xpos/w * 2 * PI) + b * cos(b * ypos/h * 2 * PI) + c * xpos / w;
}

float DOT_SIZE = 2;
class dot {
  
   int index;
  
   float x, y;
   float xspeed, yspeed;
   float xacc, yacc;
   
   int prevsize = 100;
   
   float[] prevx;
   float[] prevy;
   
   dot(float _x, float _y, int _index){
     this.x = _x;
     this.y = _y;
     this.xspeed = 0;
     this.yspeed = 0;
     this.xacc = 0;
     this.yacc = 0;
     
     this.prevx = new float[prevsize];
     this.prevy = new float[prevsize];
     
     for(int i = 0; i < prevsize; i++){
       prevx[i] = -1;
       prevy[i] = -1;
       
     }
     
     this.index = _index;
   }
   
   void bounce(){
     if(x < 0){
       x = 0;
       xspeed = -xspeed;
     }
     
     if(x > w){
        x = w;
        xspeed = -xspeed;
     }
     
     if(y < 0){
        y = 0;
        yspeed = -yspeed;
     }
     
     if(y > h){
       y = h;
       yspeed = -yspeed;
     }
   }
   
   void update(){
     xacc = dampening * calc_acc(rand[0],rand[1],rand[2],rand[3],x,y,w,h);
     yacc = dampening * calc_acc(rand[4],rand[5],rand[6],rand[7],x,y,w,h);
     
     xspeed += xacc;
     yspeed += yacc;
     
     for(int i = prevsize - 1; i > 0; i--){
       prevx[i] = prevx[i-1];
       prevy[i] = prevy[i-1];
     }
     prevx[0] = x;
     prevy[0] = y;
     
     x += xspeed;
     y += yspeed;
     
     bounce();
     

     
     show(drawmode);
   }

   void show(int showtype){
    if(showtype == 1){
      showLines();
    }else{
      showTrace();
    }
   }
   
   //SHOW MODES
   
   void showTrace(){
     stroke(dotcolor);
     strokeWeight(8);
     line(x,y,prevx[0],prevy[0]);
     stroke(color(255-red(dotcolor), 255-green(dotcolor), 255-blue(dotcolor)));
     strokeWeight(2);
     if(prevx[1] != -1 && prevy[1] != -1) line(prevx[0],prevy[0],prevx[1],prevy[1]);
   }
  
   void showLines(){
     if(index == 0) background(bgc);
     stroke(dotcolor);
     strokeWeight(DOT_SIZE);
     for(int i = 0; i < prevsize-1; i++){
       //stroke(255,((prevsize-i)/(prevsize+0.0)) * 255);
       if(prevx[i+1] != -1 && prevy[i+1] != -1) line(prevx[i],prevy[i],prevx[i+1],prevy[i+1]);
     }
     stroke(dotcolor);
     if(prevx[0] != -1 && prevy[0] != -1){
       line(x,y,prevx[0],prevy[0]);
     }else{
       ellipse(x,y,DOT_SIZE,DOT_SIZE);
     }
   }
}

//seperation in pixels
int seperation = 10;
int xnum = ceil((w-seperation)/seperation);
int ynum = ceil((h-seperation)/seperation);
int dotnum = xnum * ynum;

boolean playing = true;

dot[] dots = new dot[dotnum];

color bgc = color(255-51);

void setup(){
  size(500,500);
  smooth();
  background(bgc);
  for(int i = 0; i < RAND_SIZE; i++) rand[i] = random(-RAND_LIM, RAND_LIM);
  int x = 1;
  int y = 1;
  
  for(int i = 0; i  < dotnum; i++){
    dots[i] = new dot(x * seperation, y * seperation, i);
    x += 1;
    if(x > xnum){
     x = 1;
     y++;
    }
  }
}

void draw(){
  if(playing){
    for(int i = 0; i < dotnum; i++){
      dots[i].update();
    }
  }
}

void mousePressed(){
  if(playing == false){
    background(bgc);
  }else{
    stroke(255);
    text("click anywhere to continue",w/2,h/2);
  }
  playing = !playing;
}

color stringToColor(string c){
    string r = c.substring(1,3);
    string g = c.substring(3,5);
    string b = c.substring(5,7);
    return color(unhex(r),unhex(g),unhex(b));
}

void changeColor(string c){
  dotcolor = stringToColor(c);
  background(bgc);
}

void changeBackgroundColor(string c){
    //println(c);
    bgc = stringToColor(c);
    background(bgc);
}

void changeDrawMode(int d){
  drawmode = d;
  background(bgc);
}

void changeSeperation(int sep){
    seperation = sep;
    xnum = ceil((w-seperation)/seperation);
    ynum = ceil((h-seperation)/seperation);
    dotnum = xnum * ynum;
    dots = new dot[dotnum]
    setup();
}
