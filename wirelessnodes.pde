int h = 800;
int w = 1000;
int t0 = 0, t1 = 0, t2 = 0;

   float xacc = 0.0625;
   float yacc = 0.0625;
   float xvel = 0;
   float yvel = 0;
   float xpos = random(0,w);
   float ypos = random(0,h);
   float prevxpos = xpos;
   float prevypos = ypos;
   
   boolean on = true;
   float b_g = 226;
   float b_gdir = 0.25;
   
   float cr_r1 = random(0,127);
   float cr_r2 = random(128,255);
   float cr_g1 = random(0,127);
   float cr_g2 = random(128,255);
   float cr_b1 = random(0,127);
   float cr_b2 = random(128,255);
   
void setup(){
  size(1000,800);
  frameRate(600);
  stroke(255);
  background(0);
  frameRate(60);
  color c;  
  /*for(int i = 0; i <= w; i += 10){
    for(int j = 0; j <= h; j += 10){
      c = color(map(j,0,h,cr_r1,cr_r2),map(sqrt(sq(i-w/2) + sq(j-h/2)), 0,641,cr_g1,cr_g2),map(i,0,w,cr_b1,cr_b2));
      stroke(c,192);
      fill(c);
      ellipse(i,j,32,32);
    }
  }*/
  background(52);

}


void draw(){
  int delta = 25;
  int r = 128, g = 128, b = 128;
  int rdir = delta, gdir = delta, bdir = delta;
  
   stroke(0);
   fill(0);
   rect(0,h,w,h+100);
   fill(255);
  
  if(mousePressed == true){
    xpos = mouseX;
    ypos = mouseY;
    xvel = 0;
    yvel = 0;
    xacc = 0.0625;
    yacc = 0.0625;
   }
  
  float dist = sqrt((mouseX-pmouseX)^2+(mouseY-pmouseY)^2); 
  dist = abs(dist);
  //if(mousePressed == true){
    if(mouseX > pmouseX){
       r += rdir;
    }
    if(mouseY > pmouseY){
     g += gdir; 
    }
    if(mouseX > mouseY){
     b += bdir; 
    }
    float weight = (50/dist + 1);
    strokeWeight(2);
    
    //stroke(r,g,b);
    
    if(r >= 255) rdir = -delta;
    if(g >= 255) gdir = -delta;
    if(b >= 255) bdir = -delta;
    if(r <= 0 ) rdir = delta;
    if(g <= 0) gdir = delta;
    if(b <= 0) bdir = delta;
    
      
   int max = 3;
   
   int closestY = 0;
   for(int i = 1; i <= max; i ++){
    if(ypos < i * h/max){
      closestY = (i-1) * h/max  + h/(2*max);
      break;
    }
   }
   
   int closestX = 0;
   for(int i = 1; i <= max; i ++){
    if(xpos < i * w/max){
      closestX = (i-1) * w/max + w/(2*max);
      break;
    }
   }
   t0 ++;
   if(t0 > 60){
    t0 = 0;
    t1 ++;
   }
   if(t1 > 60){
    t1 = 0;
    t2 ++;
   }
   
   if(round(random(100)) == 1){
    xacc = -xacc; 
   }
   
   if(round(random(100)) == 1){
    yacc = -yacc; 
   }

   xvel += xacc;
   yvel += yacc;
   
   float maxvel = 8;
   
   if(xvel > maxvel){
    xvel = maxvel; 
   }else if(xvel < -maxvel){
    xvel = -maxvel; 
   }
   
   if(yvel > maxvel){
    yvel = maxvel; 
   }else if(yvel < -maxvel){
    yvel = -maxvel; 
   }
   
   

   
   xpos += xvel;
   ypos += yvel;
   
   if(xpos >= w){
    xpos = w-1;
    xvel = -xvel;
   }
   if(xpos <= 0){
    xpos = 1;
    xvel = -xvel;
   }
   
   if(ypos >= h){
    ypos = h-1;
    yvel = -yvel;
   }
   if(ypos <= 0){
    ypos = 1;
    yvel = -yvel;
   }
   
   //text("b_g = " + b_g + "   b_gdir = " + b_gdir, 10,h + 30);
  
   if(b_g >= 192){
     //text("over 255", 10,h + 70);
     b_g = 191;
     b_gdir = -0.25; 
   }else if(b_g <= 64){
     //text("under 64", 10,h + 70);
     b_g = 65;
     b_gdir = 0.25;
   }
   b_g += b_gdir;
   
   //text("b_g = " + b_g + "   b_gdir = " + b_gdir, 10,h + 50);
    
   float speed = sqrt(sq(xvel) + sq(yvel));
   color c;// = color( 128 + 127 * xacc * 16, 128 + 64 * yacc * 16,64);
   //c = color(map(sqrt(sq(xpos-w/2) + sq(ypos-h/2)), 0,641,cr_g1,cr_g2),map(xpos,0,w,cr_g1,cr_g2),map(ypos,0,h,cr_r1,cr_r2));
   c = color(0,255,0,128);
   //stroke(255 - b_g,64,b_g,map(speed, 0, sqrt(2*64), 128, 64));
   stroke(c,255);
   strokeWeight(2);
   //stroke(255,128);
   line(ceil(xpos), ceil(ypos), closestX, closestY); 
   
   //stroke(255 - b_g,64,b_g,128);
   stroke(c,255);
   //strokeWeight(map(speed, 0, sqrt(2*64), 3, 10));
   strokeWeight(6);
   //line(ceil(xpos),ceil(ypos),ceil(prevxpos),ceil(prevypos));

   stroke(255);
   strokeWeight(2);
   text("xpos = " + round(xpos) + " ypos = " + round(ypos), 10,h + 10);
   text("xvel = " + nf(xvel,2,2) + " yvel = " + nf(yvel,2,2) + " speed = " + nf(speed,2,2), 10,h + 30);
   text("xacc = " + xacc + " yacc = " + yacc, 10,h + 50);
   
   prevxpos = xpos;
   prevypos = ypos;
   
   //println("r =", r, "g = ", g, "b = ", b, "delta = ", delta, "\n");
  //}
}