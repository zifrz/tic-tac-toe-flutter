import 'package:flutter/material.dart';
import 'package:myapp/components/square.dart';
import 'package:myapp/config/theme.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  static const int boardSize = 9;
  static const List<List<int>> winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
    [0, 4, 8], [2, 4, 6], // diagonals
  ];

  late final List<String> _board;
  bool _isOTurn = true;
  int _oScore = 0;
  int _xScore = 0;
  int _filledBoxes = 0;

  @override
  void initState() {
    super.initState();
    _board = List.filled(boardSize, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildScoreBoard(),
            _buildGameBoard(),
            _buildResetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPlayerScore('Player X', _xScore),
            _buildPlayerScore('Player O', _oScore),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String player, int score) {
    return Column(
      spacing: 8,
      children: [
        Text(player, style: textStyleDarkMedium),
        Text('$score', style: textStyleDarkMedium),
      ],
    );
  }

  Widget _buildGameBoard() {
    return Expanded(
      flex: 3,
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: boardSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: (_, index) => Square(
          value: _board[index],
          onTap: () => _handleTap(index),
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return Expanded(
      child: Center(
        child: ElevatedButton.icon(
          onPressed: _resetBoard,
          onLongPress: _resetGame,
          icon: const Icon(
            Icons.restart_alt_rounded,
            color: Colors.black,
            size: 24,
            applyTextScaling: true,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          label: Text('Reset', style: textStyleLightMedium),
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (_board[index].isNotEmpty) return;

    setState(() {
      _board[index] = _isOTurn ? 'O' : 'X';
      _isOTurn = !_isOTurn;
      _filledBoxes++;
      _checkGameState();
    });
  }

  void _checkGameState() {
    for (final pattern in winPatterns) {
      if (_checkWinPattern(pattern)) return;
    }

    if (_filledBoxes == boardSize) {
      _showGameDialog('IT\'S A DRAW!!');
    }
  }

  bool _checkWinPattern(List<int> pattern) {
    final a = _board[pattern[0]];
    if (a.isEmpty) return false;

    final b = _board[pattern[1]];
    final c = _board[pattern[2]];

    if (a == b && b == c) {
      a == 'X' ? _xScore++ : _oScore++;
      _showGameDialog('$a WON!!');
      return true;
    }
    return false;
  }

  void _showGameDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(message, style: textStyleLightMedium),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetBoard();
              Navigator.pop(context);
            },
            autofocus: true,
            child: Text('Play Again!', style: textStyleLightMedium),
          ),
        ],
      ),
    );
  }

  void _resetBoard() {
    setState(() {
      _board.fillRange(0, boardSize, '');
      _filledBoxes = 0;
    });
  }

  void _resetGame() {
    setState(() {
      _xScore = 0;
      _oScore = 0;
      _resetBoard();
    });
  }
}
