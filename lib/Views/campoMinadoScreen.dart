import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'Ui/theme_Game.dart';


const int rows = 6;
const int cols = 6;
const int totalMines = 6;
const int targetBlocksToWin = 10;

class CampoMinadoGame extends StatefulWidget {
  @override
  _CampoMinadoGameState createState() => _CampoMinadoGameState();
}

class _CampoMinadoGameState extends State<CampoMinadoGame> {
  late List<List<bool>> isMine;
  late List<List<bool>> isRevealed;
  int revealedCount = 0;
  int blocksHit = 0;
  int timeElapsed = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    isMine = List.generate(rows, (r) => List.filled(cols, false));
    isRevealed = List.generate(rows, (r) => List.filled(cols, false));

    _placeMines();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeElapsed++;
      });
    });
  }

  void _placeMines() {
    int minesPlaced = 0;
    while (minesPlaced < totalMines) {
      final rand = Random();
      final row = rand.nextInt(rows);
      final col = rand.nextInt(cols);
      if (!isMine[row][col]) {
        isMine[row][col] = true;
        minesPlaced++;
      }
    }
  }

  bool _isMine(int row, int col) {
    return isMine[row][col];
  }

  void _revealBlock(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols || isRevealed[row][col]) {
      return;
    }

    isRevealed[row][col] = true;
    revealedCount++;

    if (_isMine(row, col)) {
      _handleGameLost();
    } else {
      blocksHit++;

      if (blocksHit == targetBlocksToWin) {
        _handleGameWon();
      }
    }
    setState(() {});
  }

  void _handleGameLost() {
    timer.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você perdeu!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleGameWon() {
    timer.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Você ganhou em $timeElapsed segundos!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campo Minado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ cols;
            final col = index % cols;
            return GestureDetector(
              onTap: () {
                if (!isRevealed[row][col]) {
                  _revealBlock(row, col);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: GameTheme.borderColor,
                    width: GameTheme.borderWidth,
                  ),
                  color: isRevealed[row][col] ? GameTheme.revealedBlockColor : Colors.white,
                ),
                child: Center(
                  child: isRevealed[row][col]
                      ? (_isMine(row, col)
                      ? const Icon(Icons.bolt, color: GameTheme.mineIconColor)
                      : null)
                      : null,
                ),
              ),
            );
          },
          itemCount: rows * cols,
        ),
      ),
    );
  }
}
