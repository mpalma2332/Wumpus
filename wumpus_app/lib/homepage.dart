import 'package:flutter/material.dart';
import 'package:wumpus_app/button.dart';
import 'package:wumpus_app/pixel.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _wumpusGame = WumpusGame(5, 3, 3, 5);
  late int numberofSquares = _wumpusGame.size * _wumpusGame.size;
  late int numColumInRow = _wumpusGame.size;
  late int playerPosition = point2num(_wumpusGame.player, _wumpusGame.size);
  List<int> moved = [];

  void moveUp() {
    setState(() {
      // if (playerPosition - numColumInRow >= 0) {
      //   playerPosition -= numColumInRow;
      //   _wumpusGame.interpretCommand("mu");
      // }
      _wumpusGame.interpretCommand("mu");
      playerPosition = point2num(_wumpusGame.player, _wumpusGame.size);
    });
  }

  void moveDown() {
    setState(() {
      // if (playerPosition + numColumInRow < numberofSquares) {
      //   playerPosition += numColumInRow;
      //   _wumpusGame.interpretCommand("md");
      // }
      _wumpusGame.interpretCommand("md");
      playerPosition = point2num(_wumpusGame.player, _wumpusGame.size);
    });
  }

  void moveLeft() {
    setState(() {
      // not in first column then can move left
      // if (!(playerPosition % numColumInRow == 0)) {
      //   playerPosition -= 1;
      //   _wumpusGame.interpretCommand("ml");
      // }
      _wumpusGame.interpretCommand("ml");
      playerPosition = point2num(_wumpusGame.player, _wumpusGame.size);
    });
  }

  void moveRight() {
    setState(() {
      // not in last column then can move right
      // if (!(playerPosition % numColumInRow == (numColumInRow - 1))) {
      //   playerPosition += 1;
      //   _wumpusGame.interpretCommand("mr");
      // }
      _wumpusGame.interpretCommand("mr");
      playerPosition = point2num(_wumpusGame.player, _wumpusGame.size);
    });
  }

  void shootLeft() {
    setState(() {
      // not in first column then can move left
      _wumpusGame.interpretCommand("sl");
    });
  }

  void shootRight() {
    setState(() {
      // not in first column then can move left
      _wumpusGame.interpretCommand("sr");
    });
  }

  void shootUp() {
    setState(() {
      // not in first column then can move left
      _wumpusGame.interpretCommand("su");
    });
  }

  void shootDown() {
    setState(() {
      // not in first column then can move left
      _wumpusGame.interpretCommand("sd");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 78, 78, 78),
        body: Center(
          child: AspectRatio(
              aspectRatio: 4 / 6,
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: numColumInRow),
                          itemBuilder: (BuildContext context, index) {
                            if (moved.contains(index)) {
                              // current index go back to moved index
                              if (playerPosition == index) {
                                return MyPixel(
                                    color: Color.fromARGB(255, 250, 22, 5));
                              } else {
                                // current index go to grey (never moved before area)
                                return MyPixel(
                                    color: Color.fromARGB(255, 255, 188, 182));
                              }
                            } else if (playerPosition == index) {
                              moved.add(playerPosition);
                              return MyPixel(
                                  color: Color.fromARGB(255, 250, 22, 5));
                            } else {
                              return MyPixel(color: Colors.white);
                            }
                          }),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ignore: prefer_const_constructors
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                //Backend: update status
                                child: Text(
                                  _wumpusGame.senseStr(),
                                  style: TextStyle(fontSize: 28),
                                  // textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                //Backend: update status
                                child: Text(
                                  _wumpusGame.message,
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                            Row(children: [
                              Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          MyButton(),
                                          MyButton(
                                              function: moveUp,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.arrow_drop_up,
                                                size: 50,
                                              )),
                                          MyButton(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyButton(
                                              function: moveLeft,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.arrow_left,
                                                size: 50,
                                              )),
                                          MyButton(),
                                          MyButton(
                                              function: moveRight,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.arrow_right,
                                                size: 50,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyButton(),
                                          MyButton(
                                              function: moveDown,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.arrow_drop_down,
                                                size: 50,
                                              )),
                                          MyButton(),
                                        ],
                                      )
                                    ]),
                              ),
                              Spacer(),
                              Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          MyButton(),
                                          MyButton(
                                              function: shootUp,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.whatshot,
                                                size: 50,
                                              )),
                                          MyButton(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyButton(
                                              function: shootRight,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.whatshot,
                                                size: 50,
                                              )),
                                          MyButton(),
                                          MyButton(
                                              function: shootLeft,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.whatshot,
                                                size: 50,
                                              )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          MyButton(),
                                          MyButton(
                                              function: shootDown,
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.whatshot,
                                                size: 50,
                                              )),
                                          MyButton(),
                                        ],
                                      )
                                    ]),
                              ),
                            ]),
                          ]),
                    ),
                  ),
                ],
              )),
        ));
  }
}
