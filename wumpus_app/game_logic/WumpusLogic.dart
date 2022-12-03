import 'dart:math';

final rng = Random();

class TileNode {
  bool visited = false;
  bool bats = false;
  bool pit = false;
}

enum Direction {
  up("up", [0, 1]),
  down("down", [0, -1]),
  left("left", [1, 0]),
  right("right", [-1, 0]);

  final String str;
  final List<int> arr;

  const Direction(this.str, this.arr);

  @override
  String toString() => str;

  static Direction getRandomDirection() {
    return Direction.values[rng.nextInt(Direction.values.length)];
  }
}

class WumpusGame {
  WumpusGame.standard() : this(5, 3, 3, 5);

  WumpusGame(this.size, int nBats, int nPits, this.arrows)
      : board = List.generate(size, (_) => List.filled(size, TileNode())),
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
        tile.visited = true;
        found = true;
      }
    }
    player[0] = x;
    player[1] = y;
  }

  bool move(Direction dir) {
    List<int> disp = dir.arr;
    int x = disp[0] + player[0];
    int y = disp[1] + player[1];
    if (x < 0 || x >= size || y < 0 || y >= size) {
      return false;
    }
    player[0] = x;
    player[1] = y;
    return true;
  }

  bool _moveWumpus() {
    Direction dir = Direction.getRandomDirection();
    List<int> disp = dir.arr;
    int x = disp[0] + wumpus[0];
    int y = disp[1] + wumpus[1];
    if (x < 0 || x >= size || y < 0 || y >= size) {
      return false;
    }
    wumpus[0] = x;
    wumpus[1] = y;
    return true;
  }

  bool shoot(Direction dir) {
    List<int> vector = dir.arr;
    int x = vector[0] + player[0];
    int y = vector[1] + player[1];
    bool hit = false;
    while (x < 0 || x >= size || y < 0 || y >= size) {
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
}

void main() {
  for (int i = 0; i < 5; i++) {
    print('hello ${i + 1}');
  }
}
