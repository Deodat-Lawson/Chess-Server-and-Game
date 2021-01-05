import java.util.*;  //<>//
import processing.net.*;
boolean isTurn;
Server myServer;

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
int row1 = -1, col1 = -1, row2, col2;

boolean whiteMoved = false;

int pawnP;


LinkedList<chessBoard> allRecords = new LinkedList<chessBoard>();


char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};


void setup() {
  size(800, 800);

  firstClick = true;

  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");

  myServer = new Server(this, 1234);
  isTurn = true;
  pawnP = -1;

  textAlign(CENTER);
}

void draw() {
  drawBoard();
  drawPieces();
  recieveMove();
  pawnPromo();
}






void recieveMove() {
  Client myclient = myServer.available();

  if (myclient != null) {
    String incoming = myclient.readString();

    if (incoming.substring(0, 1).equals("Z")) {
      isTurn = true;
      chessBoard c = new chessBoard(incoming);
      allRecords.add(c);
      int r1 = int(incoming.substring(129, 130));
      int c1 = int(incoming.substring(131, 132));
      int r2 = int(incoming.substring(133, 134));
      int c2 = int(incoming.substring(135, 136));
      if (r1 != 9) {
        grid[r2][c2] = grid[r1][c1];
        grid[r1][c1] = ' ';
      } else {
      grid = allRecords.getLast().grid;
      allRecords.removeLast();
      }
    } else if (incoming.equals("E")) {
      isTurn = !isTurn;
      grid = allRecords.getLast().grid; 
      allRecords.removeLast();
    }
  }
}


void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}



void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}

void mouseReleased() {
  print(firstClick);
  if (firstClick) {

    row1 = mouseY/100;
    col1 = mouseX/100;
    if (Character.isLowerCase(grid[row1][col1])) {
      firstClick = false;
    }
  } else if (isTurn) {

    row2 = mouseY/100;
    col2 = mouseX/100;

    if ((!(row2 == row1 && col2 == col1)) && ((Character.isLowerCase(grid[row1][col1]) != Character.isLowerCase(grid[row2][col2])||(Character.isUpperCase(grid[row1][col1]) != Character.isUpperCase(grid[row2][col2]) )))) {
      chessBoard c = new chessBoard(grid);
      allRecords.add(c);
      myServer.write("Z"+c.toString());


      //if (grid[row1][col1] == 'k' && row2 == 7 && col2 == 6 && grid[7][5] == ' ' && grid[7][6] == ' '&& grid[7][7] == 'r') {
      //  grid[7][6] = 'k';
      //  grid[7][4] = ' ';
      //  grid[7][5] = 'r';
      //  grid[7][7] = ' ';
      //  out();
      //} else {

        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';

        myServer.write(row1+","+col1+","+row2+","+col2);
      //}


      isTurn = false;
    } 
    firstClick = true;
  } else {
    firstClick = true;
  }
}


void pawnPromo() {
  for (int i = 0; i < 8; i++) {
    if (grid[0][i] == 'p') {
      pawnP = i;
      fill(255, 248, 220);
      rect(200, 200, 400, 400);
      fill(0);
      textSize(40);
      text("'Q' for Queen", 400, 260);
      text("'R' for Rook", 400, 360);
      text("'B' for Bishop", 400, 460);
      text("'K' for Knight", 400, 560);
    }
  }
}

void castle() {
}

void keyReleased() {
  if ((key == 'z' ||key == 'Z')&& allRecords.size() > 0) {
    grid = allRecords.getLast().grid; 
    allRecords.removeLast();
    myServer.write("E");
    isTurn = !isTurn;
  }

  if (pawnP != -1) {
    if ((key == 'q' ||key == 'Q')) {
      grid[0][pawnP] = 'q';
      pawnP = -1;
      out();
    } else if ((key == 'k' ||key == 'K')) {
      grid[0][pawnP] = 'n';
      pawnP = -1;
      out();
    } else if ((key == 'b' ||key == 'B')) {
      grid[0][pawnP] = 'b';
      pawnP = -1;
      out();
    } else if ((key == 'r' ||key == 'R')) {
      grid[0][pawnP] = 'r';
      pawnP = -1;
      out();
    }
  }
}

void out() {
  chessBoard c = new chessBoard(grid);
  myServer.write("Z"+c.toString());
  myServer.write(9+","+col1+","+row2+","+col2);
}
