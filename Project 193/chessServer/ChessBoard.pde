class chessBoard {
  char[][] grid;

  chessBoard(char[][] g) {
    grid = new char[8][8];

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        grid[i][j] = g[i][j];  
        
      }
    }
  }

  chessBoard(String s) {
    grid = new char[8][8];

    int index = 1;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        grid[i][j] = s.charAt(index);
        index+=2;      
        
      }
    }
    
  }

  String toString() {
    StringBuilder s = new StringBuilder();
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid.length; j++) {
        s.append(grid[i][j]);
        s.append(",");
      }
    }

    return s.toString();
  }
}
