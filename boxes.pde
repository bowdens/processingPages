class Graph {
  int nV;
  int nE;
  int[][] edges;
  int closestV = -1;
  int wNum = floor(w/spacing);
  int hNum = floor(h/spacing);

  Graph(int _nV){
    //println("nv = " + _nV);
    if(_nV <= 0) return;
    nV = _nV;
    edges = new int[nV][nV];
    for(int i = 0; i < nV; i++){
      for(int j = 0; j < nV; j++){
        edges[i][j] = 0;
      }
    }
  }

  boolean allEdgesFilled(){
    for(int i = 0; i < nV; i++){
      for(int j = 0; j < nV; j++){
        if(adjacent(i,j) && !isEdge(i,j)) return false;
      }
    }
    return true;
  }

  boolean validV(int v){
    return (v >= 0 && v < nV);
  }

  int neighbours(int src, int dest){
    return edges[src][dest];
  }

  boolean adjacent(int src, int dest){
    if(!validV(src) || !validV(dest)) return false;
    if(dest == src + wNum) return true;
    if(dest == src - wNum) return true;
    if(dest == src + 1 && src%(wNum)!=wNum-1) return true;
    if(dest == src - 1 && src%(wNum)!=0) return true;
    return false;
  }

  boolean isEdge(int src, int dest){
    if(!validV(src) || !validV(dest)) return false;
    return edges[src][dest] != 0;
  }

  boolean makesBox(int v1, int v2){
    //check adjacent edges
    if(!adjacent(v1, v2)) return false;

    if(v1 == v2 -1 || v1 == v2 +1){
      //horizontal case
      /*   _
       *  | | or  |_|
       */

      if(isEdge(v1-hNum, v1) && isEdge(v2-hNum, v2) && isEdge(v1-hNum, v2-hNum)) return true;
      if(isEdge(v1+hNum, v1) && isEdge(v2+hNum, v2) && isEdge(v1+hNum, v2+hNum)) return true;
    }else if(v1 == v2 -hNum || v1 == v2 + hNum){
      //vertical case
      /*  _        _
       *  _|  or  |_
       */
      if(isEdge(v1-1, v1) && isEdge(v2-1, v2) && isEdge(v1-1,v2-1)) return true;
      if(isEdge(v1+1, v1) && isEdge(v2+1, v2) && isEdge(v1+1,v2+1)) return true;
    }
    return false;
  }

  Box newBox(int v1, int v2, int player){
    if(!makesBox(v1,v2)) return null;
    if(v1 == v2 -1 || v1 == v2 +1){
      //horizontal case
      /*   _
       *  | | or  |_|
       */
      Box temp = null;
      if(isEdge(v1-hNum, v1) && isEdge(v2-hNum, v2) && isEdge(v1-hNum, v2-hNum)) temp = new Box(indexToX(v1), indexToY(v1), indexToX(v2-hNum), indexToY(v2-hNum), player);;
      if(isEdge(v1+hNum, v1) && isEdge(v2+hNum, v2) && isEdge(v1+hNum, v2+hNum)){
        Box temp2 = new Box(indexToX(v1), indexToY(v1), indexToX(v2+hNum), indexToY(v2+hNum), player);
        if(temp == null) temp = temp2;
        else temp.append(temp2);
      }
      return temp;
    }else if(v1 == v2 -hNum || v1 == v2 + hNum){
      //vertical case
      /*  _        _
       *  _|  or  |_
       */
      Box temp = null;
      if(isEdge(v1-1, v1) && isEdge(v2-1, v2) && isEdge(v1-1, v2-1)) temp = new Box(indexToX(v1), indexToY(v1), indexToX(v2-1), indexToY(v2-1), player);
      if(isEdge(v1+1, v1) && isEdge(v2+1, v2) && isEdge(v1+1, v2+1)){
        Box temp2 = new Box(indexToX(v1), indexToY(v1), indexToX(v2+1), indexToY(v2+1), player);
        if(temp == null) temp = temp2;
        else temp.append(temp2);
      }
      return temp;
    }
    return null;
  }

  void addEdge(int _src, int _dest, int _player){
    int player = (int)_player;
    int src = (int)_src;
    int dest = (int)_dest;
    //println("adding edge from " + src + " to " + dest + " in player " + player + "'s colour");
    if(validV(src) && validV(dest) && player < numPlayers && player >= 0){
      edges[src][dest] = edges[dest][src] = player+1;
    }
  }

  int indexToY(int i){
    if(!validV(i)) return 0;
    return (floor((i*spacing)/h))*spacing;
  }

  int indexToX(int i){
    if(!validV(i)) return 0;
    return ((i*spacing)%w);
  }

  int XYToIndex(int x, int y){
    return floor(x/spacing) + wNum * floor(y/spacing);
  }

  int closestV(){
    return XYToIndex(mouseX, mouseY);
  }

  void show(){
    //println(closestV() + " is the closest index");
    int c = closestV();

    //draw edges
    for(int i = 0; i < nV; i++){
      for(int j = 0; j < nV; j++){
        if(j == i) break;
        if(edges[i][j] != 0){
          strokeWeight(edgeSize + 1);
          stroke(0);
          line(indexToX(i), indexToY(i), indexToX(j), indexToY(j));
          stroke(playerColours[edges[i][j]-1]);
          strokeWeight(edgeSize);
          line(indexToX(i), indexToY(i), indexToX(j), indexToY(j));
        }
      }
    }

    //draw temp edges
    int closest = closestV();
    if(selected != -1 && currentPlayer >= 0 &&  adjacent(selected, closest)){
      stroke(0);
      strokeWeight(edgeSize * 2 + 1);
      line(indexToX(selected), indexToY(selected), indexToX(closest), indexToY(closest));
      stroke(playerColours[currentPlayer]);
      strokeWeight(edgeSize * 2);
      line(indexToX(selected), indexToY(selected), indexToX(closest), indexToY(closest));
    }


    //draw dots
    for(int i = 0; i < nV; i++){
      fill(fgc);
      stroke(0);
      strokeWeight(1);
      ellipse(indexToX(i),indexToY(i),dotSize, dotSize);
      if((i == c && currentPlayer > -1)){
        fill(playerColours[currentPlayer]);
        ellipse(indexToX(i), indexToY(i), dotSize*2, dotSize*2);
      }else if(i == selected){
        fill(playerColours[currentPlayer]);
        ellipse(indexToX(i), indexToY(i), dotSize*1.5, dotSize*1.5);
      }
    }

  }
}

class Box {
  int x1, x2, y1, y2;

  int player;

  Box next;

  Box(int _x1, int _y1, int _x2, int _y2, int _player){
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
    player = _player;
    next = null;
  }

  void show(){
    noStroke();
    fill(playerColours[player]);
    rect(x1,y1,x2-x1,y2-y1);
  }

  void append(Box b){
    Box temp = this;
    while(temp.next != null) temp = temp.next;
    temp.next = b;
  }

  void showAll(){
    Box temp = this;
    while(temp != null){
      temp.show();
      temp = temp.next;
    }
  }

  void printAll(){
    Box temp = this;
    while(temp != null){
      //println("new box created x1 = " + temp.x1 + ", y1 = " + temp.y1 + ", x2 = " + temp.x2 + ", y2 = " + temp.y2);
      temp = temp.next;
    }
  }

  int len(){
    Box temp = this;
    int count = 0;
    while(temp != null){
      temp = temp.next;
      count++;
    }
    return count;
  }
}


int h = 500, w = 500;
int spacing = 100;
color bgc = color(255-51);
color fgc = color(51);
int dotSize = 10;
int edgeSize = 6;

color[] playerColours;
int[] playerScores;
int totalPlayers = 2; //like numPlayers but different
int numPlayers = -1;
int currentPlayer = -1;
int selected = -1;

Graph maze;// = new Graph(floor(h/spacing) * floor(w/spacing));

Box boxes;

void setup(){
  size(500,600);
  background(bgc);

  maze = new Graph(floor(h/spacing) * floor(w/spacing));
  boxes = new Box(-1,-1,-1,-1,0);
  if(currentPlayer == -1) translate(spacing/2.0, spacing/2.0);
  maze.show();
  textSize(15);
  String str = "Enter a number of players to begin\n(by typing or by entering below)";
  text(str,50,h + textAscent());
}

void draw(){
  if(numPlayers > -1){
    background(bgc);
    translate(spacing/2.0, spacing/2.0);
    boxes.showAll();
    maze.show();

    translate(-spacing/2.0,-spacing/2.0);
    float boxSize = (w+0.0)/numPlayers;
    for(int i = 0; i < numPlayers; i++){
      noStroke();
      fill(playerColours[i]);
      rect(i*boxSize, h, boxSize,100);
      fill(0);
      String str = "p" + (i+1) + "\n" + playerScores[i];
      textSize(20);
      text(str, (i)*boxSize+5,h+100/2);
      fill(255);
      text(str, (i)*boxSize+5+1,h+100/2+1);
    }
    noFill();
    stroke(255,0,0);
    strokeWeight(4);
    rect(currentPlayer * boxSize, h, boxSize, 100);

    if(maze.allEdgesFilled()){
      numPlayers = -2;
      textSize(30);
      fill(51*2,128);
      int hs = highestScore();
      noStroke();
      rect(0,h/4,w,h/2);
      fill(255-51);
      if(hs == -1) text("Tie!\nClick to restart\n(or enter the number of players)",50,h/2);
      else text("Player " + (hs+1) + " wins!\nClick to restart\n(or enter the number of players)",50,h/2);
    }
  }
}

int highestScore(){
  int max = 0;
  int tie = 0;
  for(int i = 1; i < totalPlayers; i++){
    if(playerScores[i] > playerScores[max]){
      max = i;
      tie = 0;
    }else if(playerScores[i] == playerScores[max]){
      tie = 1;
    }
  }
  return tie==0?max:-1;
}

int currentPlayerIncrement(){
  currentPlayer =+ 1;
  if(currentPlayer >= numPlayers) currentPlayer = 0;
  return currentPlayer;
}

void touchEnd(){
  mousePressed();
}

void mousePressed(){
  if(numPlayers == -2){
    startGame(totalPlayers);
    return;
  }
  if(currentPlayer == -1) return;
  Box newbox = null;
  if(selected == maze.closestV()){
    selected = -1;
  }else if(selected == -1){
    selected = maze.closestV();
  }else if(maze.adjacent(selected, maze.closestV()) && maze.edges[selected][maze.closestV()] == 0){
    newbox = maze.newBox(selected, maze.closestV(), currentPlayer);
    if(newbox != null){
      //println("new box created x1 = " + newbox.x1 + ", y1 = " + newbox.y1 + ", x2 = " + newbox.x2 + ", y2 = " + newbox.y2);
      boxes.append(newbox);
      playerScores[currentPlayer] += (int)newbox.len();
      maze.addEdge(selected, maze.closestV(), currentPlayer);
    }else{
      maze.addEdge(selected, maze.closestV(), currentPlayer);
      currentPlayer += 1;
      if(currentPlayer >= numPlayers) currentPlayer = 0;
    }
    selected = -1;
  }
}

void keyPressed(){
  //println(key + " was pressed");
  if(key-'0' <= 9 && key-'0' >= 2){
    if(numPlayers == -1 || numPlayers == -2) startGame(key - '0');
  }
}

void startGame(int _numPlayers){
  //println("starting game with " + _numPlayers + " players");
  boolean toRestart = false;
  if(numPlayers != -1) toRestart = true;
  numPlayers = (int)_numPlayers;
  totalPlayers = numPlayers;
  if(numPlayers < 2){
    numPlayers = -1;
    //println(numPlayers + " is not a valid number of players");
    return;
  }
  playerColours = new color[numPlayers];
  for(int i = 0; i < numPlayers; i++) playerColours[i] = color(random(128,255), random(128,255), random(128,255));
  playerScores = new int[numPlayers];
  for(int i = 0; i < numPlayers; i++) playerScores[i] = 0;
  currentPlayer = 0;
  if(toRestart){
    setup();
  }
}
