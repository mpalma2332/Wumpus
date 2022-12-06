import 'dart:core';
import 'dart:io';
import 'dart:math';

final rng = Random();

class TileNode {
  bool visited = false;
  bool bats = false;
  bool pit = false;

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("visited: ");
    sb.write(visited);
    sb.write(", ");

    sb.write("bats: ");
    sb.write(bats);
    sb.write(", ");

    sb.write("pit: ");
    sb.write(pit);
    sb.write(", ");

    return sb.toString();
  }
}

enum Direction {
  up("up", [0, -1]),
  down("down", [0, 1]),
  left("left", [-1, 0]),
  right("right", [1, 0]);

  final String str;
  final List<int> arr;

  const Direction(this.str, this.arr);

  @override
  String toString() => str;

  static Direction getRandomDirection() {
    return Direction.values[rng.nextInt(Direction.values.length)];
  }

  static Direction getDirectionFromChar(String char) {
    if (char == "u") {
      return up;
    } else if (char == "d") {
      return down;
    } else if (char == "l") {
      return left;
    } else if (char == "r") {
      return right;
    } else {
      throw Exception("Direction: invalid direction character");
    }
  }
}

class WumpusGame {
  WumpusGame.standard() : this(5, 3, 3, 5);

  WumpusGame(this.size, int nBats, int nPits, this.arrows)
      : board =
            List.generate(size, (_) => List.generate(size, (_) => TileNode())),
        wumpus = [0, 0],
        player = [0, 0] {
    setWumpus();
    for (int i = 0; i < nBats; i++) {
      addBat();
    }
    for (int i = 0; i < nPits; i++) {
      addPit();
    }
    setPlayer();
  }

  int size;
  int arrows;
  List<List<TileNode>> board;
  List<int> player;
  List<int> wumpus;

  void setWumpus() {
    int x = rng.nextInt(size);
    int y = rng.nextInt(size);
    wumpus[0] = x;
    wumpus[1] = y;
  }

  void addBat() {
    int x = rng.nextInt(size);
    int y = rng.nextInt(size);
    board[x][y].bats = true;
  }

  void addPit() {
    int x = rng.nextInt(size);
    int y = rng.nextInt(size);
    board[x][y].pit = true;
  }

  void setPlayer() {
    int x = 0, y = 0;
    bool found = false;
    while (!found) {
      x = rng.nextInt(size);
      y = rng.nextInt(size);
      TileNode tile = board[x][y];
      if (!(tile.bats || (wumpus[0] == x && wumpus[1] == y) || tile.pit)) {
        found = true;
        tile.visited = true;
      }
    }
    player[0] = x;
    player[1] = y;
  }

  bool isValid(int x, int y) {
    return !(x < 0 || x >= size || y < 0 || y >= size);
  }

  bool move(Direction dir) {
    List<int> disp = dir.arr;
    int x = disp[0] + player[0];
    int y = disp[1] + player[1];
    if (!isValid(x, y)) {
      return false;
    }
    player[0] = x;
    player[1] = y;
    board[x][y].visited = true;
    return true;
  }

  bool _moveWumpus() {
    Direction dir = Direction.getRandomDirection();
    List<int> disp = dir.arr;
    int x = disp[0] + wumpus[0];
    int y = disp[1] + wumpus[1];
    if (!isValid(x, y)) {
      return false;
    }
    wumpus[0] = x;
    wumpus[1] = y;
    return true;
  }

  bool shoot(Direction dir) {
    //not working right now
    List<int> vector = dir.arr;
    int x = vector[0] + player[0];
    int y = vector[1] + player[1];
    bool hit = false;
    while (isValid(x, y)) {
      if (wumpus[0] == x && wumpus[1] == y) {
        hit = true;
        break;
      }
      TileNode tile = board[x][y];
      if (tile.bats && rng.nextBool()) {
        break;
      }
      x = vector[0] + player[0];
      y = vector[1] + player[1];
    }
    if (!hit && rng.nextBool()) {
      _moveWumpus();
    }
    return hit;
  }

  List<List<bool>> visitBoard() {
    List<List<bool>> result = [];
    for (int x = 0; x < board.length; x++) {
      List<bool> row = [];
      for (int y = 0; y < board[x].length; y++) {
        row.add(board[x][y].visited);
      }
      result.add(row);
    }
    return result;
  }

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    List<List<bool>> visited = visitBoard();
    for (int y = 0; y < visited.length; y++) {
      for (int x = 0; x < visited[y].length; x++) {
        if (player[0] == x && player[1] == y) {
          sb.write("■");
        } else {
          sb.write(visited[x][y] ? "□" : ".");
        }
        sb.write(" ");
      }
      sb.write("\n");
    }
    sb.write("\n");
    sb.write(senseStr());
    sb.write("\n");
    sb.write(wumpus);
    return sb.toString();
  }

  String senseStr() {
    List<bool> senses = sense();
    StringBuffer sb = StringBuffer();
    if (senses[0]) sb.write("flapping\n");
    if (senses[1]) sb.write("breeze\n");
    if (senses[2]) sb.write("smell\n");
    if (!(senses[0] || senses[1] || senses[2])) sb.write("nothing\n");
    return sb.toString();
  }

  List<bool> sense() {
    List<bool> result = [false, false, false]; // bat, pit, wumpus
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx != 0 || dy != 0) {
          int x = player[0] + dx;
          int y = player[1] + dy;
          if (isValid(x, y)) {
            TileNode node = board[x][y];
            result[0] = !result[0] ? node.bats : true;
            result[1] = !result[1] ? node.pit : true;
            result[2] = !result[2] ? (wumpus[0] == x && wumpus[1] == y) : true;
          }
        }
      }
    }
    return result;
  }
}

bool hitWumpus() {
  return (player[0] == wumpus[0] && player[1] == wumpus[1]);
}

bool interpretCommand(WumpusGame game, String comm) {
  String action = comm[0];
  String dirStr = comm[1];
  Direction dir = Direction.getDirectionFromChar(dirStr);
  if (action == "m") {
    bool moved = game.move(dir);
    if (!moved) {
      print("That is an invalid direction. Please try again!");
    }
    else if () {

    } else {
      print(game);
    }
    return false;
  } else if (action == "s") {
    bool win = game.shoot(dir);
    return win;
  } else {
    throw Exception("Interpret Command: invalid action character");
  }
}

void main() {
  WumpusGame game = WumpusGame.standard();
  print(game);
  bool gameOver = false;
  while (!gameOver) {
    String comm = stdin.readLineSync()!;
    gameOver = interpretCommand(game, comm);
  }
  print("You win!");
}
